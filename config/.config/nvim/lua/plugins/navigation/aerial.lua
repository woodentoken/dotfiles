-- Inject "### Section" markers (usually in comments) as aerial symbols.
-- Each marker is nested under the deepest existing symbol whose range contains it,
-- and kept in line order so aerial's position tracking still works.
local function insert_marker(items, marker, parent)
  for _, item in ipairs(items) do
    local end_lnum = item.end_lnum or item.lnum
    if item.lnum < marker.lnum and end_lnum >= marker.lnum then
      item.children = item.children or {}
      return insert_marker(item.children, marker, item)
    end
  end
  marker.parent = parent
  marker.level = parent and parent.level + 1 or 0
  local idx = #items + 1
  for i, item in ipairs(items) do
    if item.lnum > marker.lnum then
      idx = i
      break
    end
  end
  table.insert(items, idx, marker)
end

local MAX_BANNER_LINES = 3

-- A comment line made only of comment leaders and a run of 3+ dashes/equals,
-- e.g. "# ----", "-- ------", "// ====".
local function is_rule(line)
  return line:match("^%s*[#/;%*%-]*%s*[%-=][%-=][%-=]+%s*$") ~= nil
end

-- Text of a comment line with its leader stripped, or nil if not a comment.
local function comment_text(line)
  local text = line:match("^%s*[#/;%*%-]+%s*(.-)%s*$")
  if text and not line:match("^%s*%-[^%-]") then
    return text
  end
end

local function add_hash_markers(bufnr, items, ctx)
  -- markdown already treats "###" as a heading
  if ctx.backend_name == "markdown" or vim.bo[bufnr].filetype == "markdown" then
    return items
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local function add(lnum, col, name, banner)
    insert_marker(items, {
      kind = "Namespace",
      name = name,
      lnum = lnum,
      col = col,
      end_lnum = lnum,
      end_col = #lines[lnum],
      banner = banner,
    })
  end

  local lnum = 1
  while lnum <= #lines do
    local line = lines[lnum]
    local banner_end = nil

    -- Banner block:
    --   # ----
    --   # Title (one or more lines)
    --   # ----
    if is_rule(line) then
      local parts = {}
      for i = lnum + 1, math.min(lnum + MAX_BANNER_LINES + 1, #lines) do
        if is_rule(lines[i]) then
          if #parts > 0 then
            banner_end = i
          end
          break
        end
        local text = comment_text(lines[i])
        if not text then
          break
        end
        if text ~= "" then
          table.insert(parts, text)
        end
      end
      if banner_end then
        local first = lines[lnum + 1]
        add(lnum + 1, (first:find("%S") or 1) - 1, table.concat(parts, " "), true)
      end
    end

    if banner_end then
      lnum = banner_end + 1
    else
      -- Single line: ### Title
      local col, _, text = line:find("###+%s*(.-)%s*$")
      if col then
        -- drop trailing block-comment closers like */ or -->
        text = text:gsub("%s*%*/$", ""):gsub("%s*%-%->$", ""):gsub("%s*#+$", "")
        if text ~= "" then
          add(lnum, col - 1, text)
        end
      end
      lnum = lnum + 1
    end
  end
  return items
end

-- Draw a blank virtual line above each banner marker in the aerial pane.
-- Virtual lines don't shift buffer rows, so aerial's row -> symbol mapping is intact.
local banner_ns = vim.api.nvim_create_namespace("aerial_banner_spacing")

local function add_banner_spacing(buf)
  local util = require("aerial.util")
  local data = require("aerial.data")
  local bufnr, aer_bufnr = util.get_buffers(buf)
  if not bufnr or not aer_bufnr or not vim.api.nvim_buf_is_valid(aer_bufnr) then
    return
  end
  vim.api.nvim_buf_clear_namespace(aer_bufnr, banner_ns, 0, -1)
  if not data.has_symbols(bufnr) then
    return
  end
  local row = 0
  for _, item in data.get_or_create(bufnr):iter({ skip_hidden = true }) do
    -- skip row 0: a virt_line above the first line is hidden unless scrolled up
    if item.banner and row > 0 then
      vim.api.nvim_buf_set_extmark(aer_bufnr, banner_ns, row, 0, {
        virt_lines = { { { "", "" } } },
        virt_lines_above = true,
      })
    end
    row = row + 1
  end
end

return {
  "stevearc/aerial.nvim",
  config = function(_, opts)
    require("aerial").setup(opts)
    local render = require("aerial.render")
    local orig = render.update_aerial_buffer
    render.update_aerial_buffer = function(buf, ...)
      orig(buf, ...)
      pcall(add_banner_spacing, buf)
    end
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    backends = { "lsp", "treesitter", "markdown" },
    layout = {
      -- max_width = 45,
      -- min_width = 15,
      width = 0.2,
      -- win_opts = { number = true },
      placement = "window",
      default_direction = "right",
      resize_to_content = true,
    },
    attach_mode = "global",
    close_automatic_events = { "switch_buffer" },
    highlight_on_jump = 300,
    -- attach_mode = "window",
    keymaps = {
      ["H"] = false,
      ["J"] = false,
      ["K"] = false,
      ["L"] = false,
    },
    -- layout = { width = 150 },
    -- highlight_mode = "split_width",
    autojump = true,
    post_jump_cmd = "normal! zz",
    open_automatic = false,
    show_guides = true,
    guides = {
      mid_item = "├─ ",
      last_item = "└─ ",
      nested_top = "│  ",
      whitespace = "   ",
    },
    get_highlight = function(symbol, is_icon, is_collapsed)
      local name = symbol.name
      -- leading underscore, but not Python dunders like __init__
      if name:match("^_") and not name:match("^__.*__$") then
        return "AerialPrivate"
      end
    end,
    post_add_all_symbols = add_hash_markers,
    show_numbers = true,
    filter_kind = {
      "Class",
      "Constant",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Struct",
    },
    icons = {
      Class = "≡", -- Class symbols
      Constant = "•", -- Constants
      Enum = "∑", -- Enums
      Event = "†", -- Events
      Field = "›", -- Fields / properties
      Function = "ƒ", -- Functions
      Interface = "↕", -- Interfaces
      Method = "𝑚", -- Methods
      Namespace = "", -- "###" section markers
      Property = "▪", -- Properties
      Struct = "⧋", -- Structs
      TypeParameter = "T", -- Type parameters / generics
      Variable = "𝓍", -- Variables
    },
  },
}
