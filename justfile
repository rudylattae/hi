# Import the user's justfile if defined.
import? '~/.user.justfile'

# List all available recipes
@default:
  just --list

# Show arch and os name
@os-info:
  echo "Arch: {{arch()}}"
  echo "OS: {{os()}}"

# Install my tools (on windows)
[windows]
@install-tools:
  -winget install nushell
  -winget install Flameshot.Flameshot
  -winget install Ditto.Ditto
  -winget install Notepad++.Notepad++
  -winget install Microsoft.VisualStudioCode
  code --install-extension eamodio.gitlens
  code --install-extension nefrob.vscode-just-syntax
  code --install-extension johnpapa.vscode-peacock

# Install my tools (on linux)
[unix]
@install-tools: