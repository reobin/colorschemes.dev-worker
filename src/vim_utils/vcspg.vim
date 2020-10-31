function! GetColorValue() abort
  let l:synID = synID(line("."), col("."), 1)
  let l:name = synIDattr(l:synID, "name")
  let l:color = synIDattr(synIDtrans(l:synID), "fg#")
  if l:name == ""
    let l:name = "Normal"
  endif
  if l:color == ""
    let l:color = synIDattr(hlID("Normal"), "fg#")
  endif
  return {"group": l:name, "color": l:color}
endfunction

function! GetExtraColorValues() abort
  return [
        \ {"group": "LineNr", "color": synIDattr(hlID("LineNr"), "fg#")}
        \ , {"group": "VertSplitFg", "color": synIDattr(hlID("VertSplit"), "fg#")}
        \ , {"group": "VertSplitBg", "color": synIDattr(hlID("VertSplit"), "bg#")}
        \ , {"group": "FoldedFg", "color": synIDattr(hlID("Folded"), "fg#")}
        \ , {"group": "FoldedBg", "color": synIDattr(hlID("Folded"), "bg#")}
        \ , {"group": "StatusLine", "color": synIDattr(hlID("StatusLine"), "fg#")}
        \ , {"group": "StatusLineBackground", "color": synIDattr(hlID("StatusLine"), "bg#")}
        \ , {"group": "Cursor", "color": synIDattr(hlID("Cursor"), "bg#")}
        \ , {"group": "CursorLine", "color": synIDattr(hlID("CursorLine"), "bg#")}
        \ , {"group": "CursorLineNr", "color": synIDattr(hlID("CursorLineNr"), "fg#")}
        \ , {"group": "CursorColumn", "color": synIDattr(hlID("CursorColumn"), "bg#")}
        \ , {"group": "MatchParen", "color": synIDattr(hlID("MatchParen"), "bg#")}
        \ , {"group": "Background", "color": synIDattr(hlID("Normal"), "bg#")}
        \ ]
endfunction

" Get the last line # of the entire file
function! GetLastLine() abort
  return line("$")
endfunction

" Get the last column # of the given line
function! GetLastCol(line) abort
  call cursor(a:line, 1)
  return col("$")
endfunction

" get color values of all words in the file + some more
function! GetColorValues() abort
  let l:lastline = GetLastLine()

  let l:currentline = 1

  let l:values = []
  while l:currentline <= l:lastline
    let l:lastcol = GetLastCol(l:currentline)
    let l:currentcol = 1
    while l:currentcol <= l:lastcol
      call cursor(l:currentline, l:currentcol)
      let l:values += [GetColorValue()]
      let l:currentcol += 1
    endwhile
    let l:currentline += 1
  endwhile

  let l:values += GetExtraColorValues()

  call sort(l:values)
  call uniq(l:values)

  return l:values
endfunction

function! IsColorDark(color) abort
  let l:rawValue = a:color
endfunction

function WriteColorValues(filename) abort
  let l:defaultforeground = synIDattr(hlID("Normal"), "fg#")
  let l:default = GetColorValues()

  let l:isDark = system("python utils/is_hex_color_light.py " . trim(l:defaultforeground, '#'))

  if l:isDark
    let l:dark = l:default
  else
    set background=dark
    let l:darkforeground = synIDattr(hlID("Normal"), "fg#")
    if l:defaultforeground != l:darkforeground
      let l:dark = GetColorValues()
    else
      let l:dark = ""
    endif
  endif

  if l:isDark
    set background=light
    let l:lightforeground = synIDattr(hlID("Normal"), "fg#")
    if l:defaultforeground != l:lightforeground
      let l:light = GetColorValues()
    else
      let l:light = ""
    endif
  else
    let l:light = l:default
  endif

  let l:data = {"light": l:light, "dark": l:dark}
  call writefile([json_encode(l:data)], a:filename)
endfunction
