# This makes it so we can have similar named recipes for different operating systems
set allow-duplicate-recipes := true

# load .env files for customization
set dotenv-load # load .env files

# Import the user's main justfile if defined.
import? '~/.config/hi/main.justfile'

# Manage "hi" configuration
mod self

# Manage git repositories in standard location
mod repo 

# Manage packages in your main.justfile 🚧 🧪
mod pkg

# List all available recipes
@_default:
  just --justfile {{source_file()}} --list --unsorted
