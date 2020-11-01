function! GetColorValue() abort
  let l:synID = synID(line('.'), col('.'), 1)
  let l:name = synIDattr(l:synID, 'name')
  let l:color = synIDattr(synIDtrans(l:synID), 'fg#')
  if l:name == ''
    let l:name = 'Normal'
  endif
  if l:color == ''
    let l:color = synIDattr(hlID('Normal'), 'fg#')
  endif
  return {'group': l:name, 'color': l:color}
endfunction

function! GetExtraColorValues() abort
  return [
        \ {'group': 'LineNr', 'color': synIDattr(hlID('LineNr'), 'fg#')}
        \ , {'group': 'VertSplitFg', 'color': synIDattr(hlID('VertSplit'), 'fg#')}
        \ , {'group': 'VertSplitBg', 'color': synIDattr(hlID('VertSplit'), 'bg#')}
        \ , {'group': 'FoldedFg', 'color': synIDattr(hlID('Folded'), 'fg#')}
        \ , {'group': 'FoldedBg', 'color': synIDattr(hlID('Folded'), 'bg#')}
        \ , {'group': 'StatusLine', 'color': synIDattr(hlID('StatusLine'), 'fg#')}
        \ , {'group': 'StatusLineBackground', 'color': synIDattr(hlID('StatusLine'), 'bg#')}
        \ , {'group': 'Cursor', 'color': synIDattr(hlID('Cursor'), 'bg#')}
        \ , {'group': 'CursorLine', 'color': synIDattr(hlID('CursorLine'), 'bg#')}
        \ , {'group': 'CursorLineNr', 'color': synIDattr(hlID('CursorLineNr'), 'fg#')}
        \ , {'group': 'CursorColumn', 'color': synIDattr(hlID('CursorColumn'), 'bg#')}
        \ , {'group': 'MatchParen', 'color': synIDattr(hlID('MatchParen'), 'bg#')}
        \ , {'group': 'Background', 'color': synIDattr(hlID('Normal'), 'bg#')}
        \ ]
endfunction

" Get the last line # of the entire file
function! GetLastLine() abort
  return line('$')
endfunction

" Get the last column # of the given line
function! GetLastCol(line) abort
  call cursor(a:line, 1)
  return col('$')
endfunction

" Get color values of all words in the file + some more
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

function! IsHexColorLight(color) abort
  let l:rawColor = trim(a:color, '#')

  let l:red = str2nr(substitute(l:rawColor, '\(.\{2\}\).\{4\}', '\1', 'g'), 16)
  let l:green = str2nr(substitute(l:rawColor, '.\{2\}\(.\{2\}\).\{2\}', '\1', 'g'), 16)
  let l:blue = str2nr(substitute(l:rawColor, '.\{4\}\(.\{2\}\)', '\1', 'g'), 16)

  let l:brightness = ((l:red * 299) + (l:green * 587) + (l:blue * 114)) / 1000

  if l:brightness > 155
    return 1
  else
    return 0
  endif
endfunction

function WriteColorValues(filename) abort
  if exists('g:colors_name') && g:colors_name != 'default'
    try
      let l:defaultforeground = synIDattr(hlID('Normal'), 'fg#')
      let l:default = GetColorValues()

      let l:isDark = IsHexColorLight(l:defaultforeground)

      let l:data = {}

      if l:isDark
        set background=light
        let l:lightforeground = synIDattr(hlID('Normal'), 'fg#')
        if l:defaultforeground != l:lightforeground
          let l:data.light = GetColorValues()
        endif
      else
        let l:data.light = l:default
      endif

      if l:isDark
        let l:data.dark = l:default
      else
        set background=dark
        let l:darkforeground = synIDattr(hlID('Normal'), 'fg#')
        if l:defaultforeground != l:darkforeground
          let l:data.dark = GetColorValues()
        endif
      endif

      if l:data != {}
        call writefile([json_encode(l:data)], a:filename)
      endif
    catch
      echo 'error'
    endtry
  endif
endfunction
