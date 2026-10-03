if exists("b:current_syntax")
  finish
endif

" Prompt
syntax match dapReplPrompt "^dap> "

" Table borders and ellipses, dimmed so the data stands out
syntax match dapReplBorder "[─│┆┌┐└┘├┤┬┴┼╞╡╪═…]"

" Numbers: ints, floats, scientific notation
syntax match dapReplNumber "\v-?<\d+(\.\d+)?([eE][-+]?\d+)?>"

" Quoted strings
syntax region dapReplString start=+'+ skip=+\\'+ end=+'+ oneline
syntax region dapReplString start=+"+ skip=+\\"+ end=+"+ oneline

" Python constants and polars dtypes
syntax keyword dapReplConstant True False None null NaN nan inf
syntax keyword dapReplType str bool f32 f64 i8 i16 i32 i64 u8 u16 u32 u64

" polars headers
syntax match dapReplLabel "^\(shape\|Series\):"

" Tracebacks and exception lines
syntax match dapReplError "^\(Traceback\|[A-Za-z_.]*\(Error\|Exception\)\>\).*$"

highlight default link dapReplPrompt Function
highlight default link dapReplBorder Comment
highlight default link dapReplNumber Number
highlight default link dapReplString String
highlight default link dapReplConstant Boolean
highlight default link dapReplType Type
highlight default link dapReplLabel Title
highlight default link dapReplError ErrorMsg

let b:current_syntax = "dap-repl"
