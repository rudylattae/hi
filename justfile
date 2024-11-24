# This makes it so we can have similar named recipes for different operating systems
set allow-duplicate-recipes := true

# load .env files for customization
set dotenv-load # load .env files

# Import the user's justfile if defined.
import? '~/.user.justfile'

# Manage "hi" configuration
mod self

# Manage git repositories in standard location
mod repo 

# Manage modules in your user.justfile
mod mod

# List all available recipes
@_default:
  just --justfile {{source_file()}} --list

