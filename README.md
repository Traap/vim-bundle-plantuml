# vim-bundle-plantuml

Personal Vim/Neovim commands for compiling and viewing PlantUML diagrams.

## Requirements

- `/usr/sbin/plantuml`
- `PDF_VIEWER` set for `:PlantUmlView` and `:PlantUmlAssemble`

## Usage

Open a PlantUML file such as `diagram.puml`, then run:

```vim
:PlantUmlCompile
```

This writes `diagram.png` next to `diagram.puml`.

Available commands:

- `:PlantUmlCompile` generates a PNG from the current buffer.
- `:PlantUmlView` opens the generated PNG with `$PDF_VIEWER`.
- `:PlantUmlAssemble` compiles and then views the PNG.
- `:PlantUmlClear` resets the viewer-open flag.
