set allow-duplicate-recipes := true # This makes it so we can have similar named recipes for different operating systems

# Import the user's justfile if defined.
import? '~/.user.justfile'

# Manage "hi" configuration
mod self


# List all available recipes
@_default:
  echo 'Here is a list of stuff I can assist with'
  just --list --justfile {{source_file()}}
