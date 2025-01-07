hi_clone_base_dir := absolute_path(env('HI_CLONE_BASE_DIR', append('/hi', home_dir())))
hi_github_base_dir := absolute_path(append('/github.com', hi_clone_base_dir))
main_justfile_path := "$HOME/.config/hi/main.justfile"

tldr_info := '# Use cases
Clone a package from <repo_name> on github and add it as a module in your main.justfile.

> hi pkg add mypackage repo_name "Package description"

After adding a package, it will be available as a module via hi

> hi
Available recipes:
  mypackage ...        # Package description
'

# List all available recipes
@_default:
  just --justfile {{source_file()}} --list

# TL;DR; See usage examples and quick tips
@tldr:
  echo "{{tldr_info}}"

# Clone a package repo and add it as a module
[unix]
add name repo_name description:
  #!/usr/bin/env sh
  repo_dir={{hi_github_base_dir}}/{{repo_name}}
  line1="# {{description}}"
  line2="mod? {{name}} '$repo_dir/justfile'"

  echo "Justfile: {{main_justfile_path}}"

  if [ ! -d $repo_dir ]; then
    just repo clone {{repo_name}}
  else
    echo "Repo already exists. Skipping."
  fi
  if [ ! -d $repo_dir ]; then
    echo "ERROR Unable to find local copy of repository."
    exit 0
  fi
  if [ -f {{main_justfile_path}} ]; then
    echo "Adding module to justfile at {{main_justfile_path}}"
    if ! grep -q "^$line2\$" {{main_justfile_path}}; then
        printf "\n" >> {{main_justfile_path}}
        echo $line1 >> {{main_justfile_path}}
        echo $line2 >> {{main_justfile_path}}
        echo "Added module definition to {{main_justfile_path}}"
    else
      echo "Module already registerd in {{main_justfile_path}}. Skipping."
    fi
  else
      echo "Unable to find {{main_justfile_path}} file."
      echo "Add the definition manually"
      echo $line1
      echo $line2
  fi