# load .env files for customization
set dotenv-load # load .env files

# List all available recipes
@_default:
  just --justfile {{source_file()}} --list --unsorted

# Run the application
@hi *args:
  v run hi {{args}}

# Build the application
@build:
  v -o build/hi hi

# Format the code
@format:
  v fmt -w .
alias fmt := format

# Run the tests
@test:
  v test .

# Run the tests and build the application
@ci: test build