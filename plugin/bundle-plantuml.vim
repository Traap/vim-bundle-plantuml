" {{{ bundle-plantuml.vim 

if exists('g:loaded_bundle_plantuml')
  finish
endif
let g:loaded_bundle_plantuml=1

" -------------------------------------------------------------------------- }}}
" {{{ PlantUml functions 

function! InitUmlSettings()

  let g:puml_viewer_open = 0 
  let g:puml_wsl = (substitute(system('uname -r'), '\n', '', '') =~ 'Microsoft')

  if g:puml_wsl || has("win32unix")
    let g:puml_viewer = 'SumatraPDF.exe'
  else
    let g:puml_viewer = 'okular'
  endif

endfunction

function! RunPumlJavaCommand()

  " Example: !java -Djava.awt.headless=true "foo.puml"
  let s:puml_args = '-Djava.awt.headless=true'

  let s:puml_jar = '~/git/plantuml/plantuml.jar'

  let g:puml_cmd = '!java ' . s:puml_args .  \ ' -jar ' . s:puml_jar .  \ ' "'
  . expand('%') . '"'

  silent execute g:puml_cmd

endfunction

function! RunPumlViewCommand()
  " Example: !okular "foo.png" 2>/dev/null&
  if !g:puml_viewer_open

    let g:puml_viewer_open = 1

    let g:puml_view = '!' . g:puml_viewer .  \ ' "'. expand('%<') . '.png"'
    .  \ ' 2>/dev/null&' silent execute g:puml_view

  endif
endfunction

function! GenerateUmlDiagram()
  call RunPumlJavaCommand()
  call RunPumlViewCommand()
endfunction

function! ClearUmlLaunchFlag()
  let g:puml_viewer_open = 0
endfunction

" -------------------------------------------------------------------------- }}}