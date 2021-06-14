" {{{ bundle-plantuml.vim

if exists('g:loaded_bundle_plantuml')
  finish
endif
let g:loaded_bundle_plantuml=1

" -------------------------------------------------------------------------- }}}
" {{{ Archlinux and Windows Subsystem for Linux check

let g:os_arch = trim(system("cat /etc/issue | rg 'Arch Linux' -c"))
let g:os_wsl  = (substitute(system('uname -r'), '\n', '', '') =~ 'Microsoft') ||
              \ (substitute(system('uname -r'), '\n', '', '') =~ 'WSL2')

" -------------------------------------------------------------------------- }}}
" {{{ Init UML settings.

function! InitUmlSettings()

  let g:puml_viewer_open = 0

  if g:os_wsl || has("win32unix")
    let g:puml_viewer = 'SumatraPDF.exe'
  else
    let g:puml_viewer = 'okular'
  endif

endfunction

" -------------------------------------------------------------------------- }}}
" {{{ Run Plant UML Compile Command

function! RunPumlJavaCommand()

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

function! RunPumlViewCommand()
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

function! GenerateUmlDiagram()
  call RunPumlJavaCommand()
  call RunPumlViewCommand()
endfunction

" -------------------------------------------------------------------------- }}}
" {{{ Clear UML Lanuch Flag

function! ClearUmlLaunchFlag()
  let g:puml_viewer_open = 0
endfunction

" -------------------------------------------------------------------------- }}}
