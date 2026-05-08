" {{{ bundle-plantuml.vim

if exists('g:loaded_bundle_plantuml')
  finish
endif
let g:loaded_bundle_plantuml=1

" -------------------------------------------------------------------------- }}}
" {{{ Initialize pdf viewer

let g:puml_viewer_open = 0
let s:puml_executable = '/usr/sbin/plantuml'

let s:pdf_viewer = getenv('PDF_VIEWER')
if s:pdf_viewer != v:null && !empty(s:pdf_viewer)
  let g:traap_pdf_viewer = s:pdf_viewer
else
  echo "Warning: (plantuml) PDF_VIEWER is not defined."
endif

" -------------------------------------------------------------------------- }}}
" {{{ Initialize global commands.

command! PlantUmlClear    call s:plantuml_clear()
command! PlantUmlAssemble call s:plantuml_assemble_diagram()
command! PlantUmlCompile  call s:plantuml_compile_diagram()
command! PlantUmlView     call s:plantuml_view_diagram()

" -------------------------------------------------------------------------- }}}
" {{{ Run Plant UML Compile Command

function! s:plantuml_java_options() abort
  let l:headless = '-Djava.awt.headless=true'
  let l:current = $JAVA_TOOL_OPTIONS

  if empty(l:current)
    return l:headless
  endif

  if l:current =~# '\V-Djava.awt.headless='
    return l:current
  endif

  return l:headless . ' ' . l:current
endfunction

function! s:plantuml_compile_diagram() abort
  if !executable(s:puml_executable)
    echoerr '(plantuml) ' . s:puml_executable . ' is not executable.'
    return
  endif

  let l:save_java_tool_options = $JAVA_TOOL_OPTIONS
  let $JAVA_TOOL_OPTIONS = s:plantuml_java_options()

  try
    call system([s:puml_executable, '-tpng', expand('%:p')])
  finally
    let $JAVA_TOOL_OPTIONS = l:save_java_tool_options
  endtry

  if v:shell_error != 0
    echoerr '(plantuml) PNG generation failed for ' . expand('%:p')
  endif
endfunction

" -------------------------------------------------------------------------- }}}
" {{{ Run Plant UML View Command

function! s:plantuml_view_diagram() abort
  " Example: !okular "foo.png" 2>/dev/null&
  if !g:puml_viewer_open

    let g:puml_viewer_open = 1

    let g:puml_view = '!' . s:pdf_viewer .
                    \ ' "'. expand('%<') . '.png"' .
                    \ ' 2>/dev/null&'

    silent execute g:puml_view

  endif
endfunction

" -------------------------------------------------------------------------- }}}
" {{{ Generate Uml Diagram

function! s:plantuml_assemble_diagram() abort
  call s:plantuml_compile_diagram()
  call s:plantuml_view_diagram()
endfunction

" -------------------------------------------------------------------------- }}}
" {{{ Clear UML Lanuch Flag

function! s:plantuml_clear() abort
  let g:puml_viewer_open = 0
endfunction

" -------------------------------------------------------------------------- }}}
