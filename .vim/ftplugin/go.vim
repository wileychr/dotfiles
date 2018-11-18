" Go specific settings
"
"
setlocal noexpandtab
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

" People are a little more tolerant of long lines in golang.
autocmd WinEnter * match OverLength /\%101v.\+/
autocmd BufEnter * match OverLength /\%101v.\+/
