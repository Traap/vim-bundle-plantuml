" {{{ bundle-plantuml.vim

if exists('g:loaded_bundle_plantuml')
  finish
endif
let g:loaded_bundle_plantuml=1

" -------------------------------------------------------------------------- }}}
" {{{ Initialize pdf viewer

let g:puml_viewer_open = 0

if has("wsl") || has("win32unix")
  let g:puml_viewer = 'SumatraPDF.exe'
else
  let g:puml_viewer = 'okular'
endif

" -------------------------------------------------------------------------- }}}
" {{{ Initialize global commands.

command! PlantUmlClear    call s:plantuml_clear()
command! PlantUmlAssemble call s:plantuml_assemble_diagram()
command! PlantUmlCompile  call s:plantuml_compile_diagram()
command! PlantUmlView     call s:plantuml_view_diagram()

" -------------------------------------------------------------------------- }}}
" {{{ Run Plant UML Compile Command

function! s:plantuml_compile_diagram() abort

  " Example: !java -Djava.awt.headless=true "foo.puml"
  let s:puml_args = '-Djava.awt.headless=true'

  let s:puml_jar = '~/git/plantuml/plantuml.jar'

  let g:puml_cmd = '!java ' . s:puml_args .
                 \ ' -jar ' . s:puml_jar .
                 \ ' "' . expand('%') . '"'

  silent execute g:puml_cmd

endfunction

" -------------------------------------------------------------------------- }}}
" {{{ Run Plant UML View Command

function! s:plantuml_view_diagram() abort
  " Example: !okular "foo.png" 2>/dev/null&
  if !g:puml_viewer_open

    let g:puml_viewer_open = 1

    let g:puml_view = '!' . g:puml_viewer .
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
