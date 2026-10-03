return {
  "swaits/turbo-debug.nvim",
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "Weissle/persistent-breakpoints.nvim",
  },

  init = function()
    -- turbo-debug's plugin/ file calls vim.pack.add() with "owner/repo"
    -- shorthand, which vim.pack can't clone. lazy.nvim already provides
    -- those plugins, so drop shorthand specs before they reach vim.pack.
    local pack_add = vim.pack.add
    vim.pack.add = function(specs, opts)
      specs = vim.tbl_filter(function(spec)
        local src = type(spec) == "table" and spec.src or spec
        return not (type(src) == "string" and src:match("^[%w_.-]+/[%w_.-]+$"))
      end, specs)
      if #specs > 0 then
        return pack_add(specs, opts)
      end
    end

    -- The stock R adapter shells out to Rscript at setup to check for the
    -- vscDebugger package, blocking startup ~200ms. Register it unconditionally
    -- and run that check when an R session actually launches instead.
    package.preload["turbo-debug.adapters.r"] = function()
      local loader = require("turbo-debug.adapters.init")
      return {
        register = function(dap)
          local R = loader.find_executable({ "R" })
          if not R then return end
          loader.register(dap, "r", function(callback)
            vim.system(
              { "Rscript", "-e", "if (!requireNamespace('vscDebugger', quietly=TRUE)) quit(status=1)" },
              {},
              vim.schedule_wrap(function(res)
                if res.code ~= 0 then
                  vim.notify("R debugging needs the vscDebugger package", vim.log.levels.ERROR)
                  return
                end
                callback({ type = "executable", command = R, args = { "-e", "vscDebugger::.vsc.listenForDAP()" } })
              end)
            )
          end, {
            {
              type = "r",
              request = "launch",
              name = "Launch R file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
          }, { "r", "rmd" })
        end,
      }
    end
  end,

  config = function()
    local dap = require("dap")
    local dap_repl = require("dap.repl")

    -- ============================================================
    -- Setup and layout
    -- ============================================================
    require("turbo-debug").setup({
      stop_on_entry_when_no_breakpoints = false,
      keys = { eval_intuitive = "I", eval_toggle = "~" },
      console_height = math.floor(vim.o.lines * 0.25),
      dapui = {
        controls = { enabled = false },
        layouts = {
          {
            position = "right",
            size = 0.4, -- columns
            elements = {
              { id = "repl",    size = 0.8 },
              { id = "console", size = 0.2 },
            },
          },
          {
            position = "left",
            size = 0.25, -- columns
            elements = {
              { id = "stacks",      size = 0.3 },
              { id = "breakpoints", size = 0.3 },
              { id = "watches",     size = 0.4 },
            },
          },
          {
            position = "bottom",
            size = 0.25, -- rows
            elements = {
              { id = "scopes", size = 1.0 },
            },
          },
        },
      },
    })

    -- ============================================================
    -- Toggle keymap
    -- ============================================================
    -- Restore the cursor position and recenter after the layout opens/closes.
    vim.keymap.set("n", "<leader>dd", function()
      local win = vim.api.nvim_get_current_win()
      local pos = vim.api.nvim_win_get_cursor(win)
      require("turbo-debug").toggle()
      vim.defer_fn(function()
        if not vim.api.nvim_win_is_valid(win) then return end
        pcall(vim.api.nvim_win_set_cursor, win, pos)
        vim.api.nvim_win_call(win, function() vim.cmd("normal! zz") end)
      end, 100)
    end, { desc = "Toggle debug mode" })

    -- ============================================================
    -- Window helpers
    -- ============================================================
    -- A "source" window is a regular, non-floating window that isn't a debug pane.
    local function is_source(win)
      if not (win and vim.api.nvim_win_is_valid(win)) then return false end
      if vim.api.nvim_win_get_config(win).relative ~= "" then return false end
      local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
      return ft ~= "" and ft ~= "dap-repl" and ft ~= "TurboDebugBar" and not ft:match("^dapui_")
    end

    local function find_win(pred)
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if pred(win) then return win end
      end
    end

    local function repl_win()
      return find_win(function(win)
        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "dap-repl"
      end)
    end

    -- ============================================================
    -- REPL mode state
    -- ============================================================
    -- "intuitive": results print as plain values (no expandable variable tree).
    -- "explicit":  results show dap's default expandable attribute tree.
    local repl_mode = "intuitive"

    -- Source window to jump back to when leaving the REPL.
    local return_win

    -- ============================================================
    -- Pane backgrounds
    -- ============================================================
    -- Derived from the colorscheme's Normal background so they track theme changes.
    local function shade(color, dr, dg, db)
      local sign = vim.o.background == "light" and -1 or 1
      local function channel(div, delta)
        local value = math.floor(color / div) % 256 + sign * delta
        return math.max(0, math.min(255, value))
      end
      return string.format("#%02x%02x%02x", channel(65536, dr), channel(256, dg), channel(1, db))
    end

    local function define_pane_colors()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
      local base = normal.bg or 0x1e1e1e
      vim.api.nvim_set_hl(0, "DebugConsoleBg", { fg = normal.fg, bg = shade(base, 8, 8, 8) })
      vim.api.nvim_set_hl(0, "DebugReplIntuitiveBg", { fg = normal.fg, bg = shade(base, 4, 8, 18) })
      vim.api.nvim_set_hl(0, "DebugReplExplicitBg", { fg = normal.fg, bg = shade(base, 18, 8, 4) })
    end

    local function pane_bg_group(ft)
      if ft == "dapui_console" then return "DebugConsoleBg" end
      if ft == "dap-repl" then
        return repl_mode == "intuitive" and "DebugReplIntuitiveBg" or "DebugReplExplicitBg"
      end
    end

    -- Swap the Normal/NormalNC entries in each pane's winhighlight, keeping any others.
    local function apply_pane_backgrounds()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local group = pane_bg_group(vim.bo[vim.api.nvim_win_get_buf(win)].filetype)
        if group and vim.api.nvim_win_get_config(win).relative == "" then
          local parts = {}
          for _, item in ipairs(vim.split(vim.wo[win].winhighlight, ",", { trimempty = true })) do
            if not item:match("^Normal:") and not item:match("^NormalNC:") then
              parts[#parts + 1] = item
            end
          end
          parts[#parts + 1] = "Normal:" .. group
          parts[#parts + 1] = "NormalNC:" .. group
          local value = table.concat(parts, ",")
          if vim.wo[win].winhighlight ~= value then vim.wo[win].winhighlight = value end
        end
      end
    end

    define_pane_colors()

    local pane_bg_augroup = vim.api.nvim_create_augroup("DebugPaneBackgrounds", { clear = true })
    vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave", "BufWinEnter" }, {
      group = pane_bg_augroup,
      callback = function() vim.schedule(apply_pane_backgrounds) end,
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = pane_bg_augroup,
      callback = function()
        define_pane_colors()
        apply_pane_backgrounds()
      end,
    })

    -- ============================================================
    -- REPL mode indicator
    -- ============================================================
    local function show_repl_mode()
      local win = repl_win()
      if not win then return end
      local intuitive = repl_mode == "intuitive"
      vim.wo[win].winbar = " REPL · " .. (intuitive and "intuitive (I)" or "explicit (E)")
      -- Intuitive mode prints tables and arrays; wrapping breaks their alignment.
      vim.wo[win].wrap = not intuitive
      apply_pane_backgrounds()
    end

    local function toggle_repl_mode()
      repl_mode = repl_mode == "intuitive" and "explicit" or "intuitive"
      show_repl_mode()
    end

    -- Show the mode as soon as a session starts, after turbo-debug has set its own title.
    dap.listeners.after.event_initialized["repl-mode-indicator"] = function()
      vim.defer_fn(show_repl_mode, 100)
    end

    -- ============================================================
    -- Entering / leaving the REPL (E and I)
    -- ============================================================
    local function leave_repl()
      vim.cmd("stopinsert")
      vim.schedule(function()
        local target = is_source(return_win) and return_win or find_win(is_source)
        if target then vim.api.nvim_set_current_win(target) end
        local session = dap.session()
        if session and session.stopped_thread_id and session.current_frame then
          dap.focus_frame()
        end
      end)
    end

    local function enter_repl(mode)
      return function()
        local repl = repl_win()
        if not repl then return end
        repl_mode = mode
        show_repl_mode()

        local cur = vim.api.nvim_get_current_win()
        if is_source(cur) then return_win = cur end

        vim.api.nvim_set_current_win(repl)
        vim.keymap.set("i", "<Esc>", leave_repl, {
          buffer = vim.api.nvim_win_get_buf(repl),
          desc = "Leave REPL and return to the current frame",
        })
        vim.keymap.set({ "i", "n" }, "~", toggle_repl_mode, {
          buffer = vim.api.nvim_win_get_buf(repl),
          desc = "Toggle REPL mode",
        })
        vim.cmd("startinsert!")
      end
    end

    local actions = require("turbo-debug.mode").actions()
    actions.eval = enter_repl("explicit")            -- E
    actions.eval_intuitive = enter_repl("intuitive") -- I

    local function is_table_line(line)
      for _, ch in ipairs({ "│", "┆", "─", "═" }) do
        if line:find(ch, 1, true) then return true end
      end
      return false
    end

    -- Break long lines at commas so they fit the REPL pane; leave tables alone.
    local function reflow(text, width)
      local out = {}
      for _, line in ipairs(vim.split(text, "\n", { plain = true })) do
        if vim.fn.strdisplaywidth(line) <= width or is_table_line(line) then
          out[#out + 1] = line
        else
          local pieces = vim.split(line, ", ", { plain = true })
          local current = ""
          for idx, piece in ipairs(pieces) do
            if idx < #pieces then piece = piece .. "," end
            local candidate = current == "" and piece or (current .. " " .. piece)
            if current ~= "" and vim.fn.strdisplaywidth(candidate) > width then
              out[#out + 1] = current
              current = "    " .. piece
            else
              current = candidate
            end
          end
          out[#out + 1] = current
        end
      end
      return table.concat(out, "\n")
    end

    dap.listeners.before.evaluate["intuitive-repl"] = function(_, err, response, request)
      if repl_mode == "intuitive" and not err and response and request and request.context == "repl" then
        response.variablesReference = 0
        local win = repl_win()
        if win and type(response.result) == "string" then
          response.result = reflow(response.result, vim.api.nvim_win_get_width(win) - 1)
        end
      end
    end

    -- Tidy program output before it reaches the REPL: strip terminal colour
    -- codes, and keep it off the line holding the command you typed.
    dap.listeners.before.event_output["tidy-repl-output"] = function(_, body)
      if not body or type(body.output) ~= "string" then return end
      body.output = (body.output:gsub("\27%[[%d;?]*%a", ""))

      local win = repl_win()
      if not win then return end
      local buf = vim.api.nvim_win_get_buf(win)
      local count = vim.api.nvim_buf_line_count(buf)
      if count < 2 then return end
      local above_prompt = vim.api.nvim_buf_get_lines(buf, count - 2, count - 1, false)[1]
      if above_prompt and above_prompt:find("^dap> ") then
        body.output = "\n" .. body.output
      end
    end

    -- ============================================================
    -- Rich REPL commands (Python)
    -- ============================================================
    -- Output goes to the Console pane: `.r expr` prints, `.i expr` inspects.
    local rich_console = '__import__("rich.console").console.Console(file=__import__("sys").__stdout__)'

    local function rich_command(template)
      return function(expr)
        local session = dap.session()
        if not session then return end
        if expr == "" then
          dap_repl.append("Give an expression, e.g. .r raw_sim_data")
          return
        end
        session:evaluate({ expression = template:format(expr), context = "repl" }, function(err)
          if err then dap_repl.append(tostring(err)) end
        end)
      end
    end

    dap_repl.commands = vim.tbl_extend("force", dap_repl.commands, {
      custom_commands = {
        [".r"] = rich_command(rich_console .. '.print(%s, no_wrap=True, overflow="crop")'),
        [".i"] = rich_command('__import__("rich").inspect(%s, console=' .. rich_console .. ")"),
      },
    })

    -- ============================================================
    -- Help popup patch
    -- ============================================================
    -- Rewrites turbo-debug's "(E)val in REPL" line into separate (E)xplicit
    -- and (I)ntuitive entries, then resizes the popup to fit.
    local help = require("turbo-debug.help")
    local open_help = help.open
    help.open = function()
      open_help()
      pcall(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(win).relative ~= "" then
            local buf = vim.api.nvim_win_get_buf(win)
            for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
              local col = line:find(")val in REPL", 1, true)
              if col then
                local explicit = "xplicit REPL (attribute tree)"
                local added = {
                  "      (I)ntuitive REPL (plain values)",
                  "      (~) toggle REPL mode",
                }
                vim.bo[buf].modifiable = true
                vim.api.nvim_buf_set_text(buf, i - 1, col, i - 1, #line, { explicit })
                vim.api.nvim_buf_set_lines(buf, i, i, false, added)
                vim.bo[buf].modifiable = false

                local ns = vim.api.nvim_create_namespace("repl-help-keys")
                local needed = col + #explicit
                for offset, text in ipairs(added) do
                  local row = i + offset - 1
                  local function mark(c, group)
                    vim.api.nvim_buf_set_extmark(buf, ns, row, c, { end_col = c + 1, hl_group = group })
                  end
                  mark(6, "TurboDebugHelpParen")
                  mark(7, "TurboDebugHelpKey")
                  mark(8, "TurboDebugHelpParen")
                  needed = math.max(needed, #text)
                end

                if needed + 2 > vim.api.nvim_win_get_width(win) then
                  vim.api.nvim_win_set_width(win, needed + 2)
                end
                vim.api.nvim_win_set_height(win, vim.api.nvim_win_get_height(win) + #added)
                return
              end
            end
          end
        end
      end)
    end

    -- ============================================================
    -- Python adapter configuration
    -- ============================================================
    for _, cfg in ipairs(dap.configurations.python or {}) do
      cfg.guiEventLoop = "none"
      cfg.variablePresentation = { protected = "group" }
      -- cfg.justMyCode = false -- uncomment to step into library code
    end
  end,
}
