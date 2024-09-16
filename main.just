set allow-duplicate-recipes := true

# Import the user's justfile if defined.
import? '~/.user.justfile'

# Manage "hi" itself
mod self

# Manage dofiles for the current user
mod? dotfiles '~/dotfiles/dotfiles.just'
mod? machine '~/dotfiles/machine.just'


# List all available recipes
@_default:
  echo 'Here is a list of stuff I can assist with'
  just --list --justfile {{source_file()}}

# Show arch and os name
@os-info:
  echo 'Arch: {{arch()}}'
  echo 'OS: {{os()}}'

# Install my tools (on linux)
[unix]
@install-tools:
  echo "Installing on LINUX!!!"


# Install my tools (on windows)
[windows]
@install-tools:
  echo "Installing on WInBLOWS!"