hi_clone_base_dir := absolute_path(env('HI_CLONE_BASE_DIR', append('/hi', home_dir())))
hi_github_base_dir := absolute_path(append('/github.com', hi_clone_base_dir))
user_justfile := '~/.user.justfile'

tldr_info := '# Use cases
Clone a mod from <repo_name> on github. Add the mod to your ~/.user.justfile 
if it exists.

> hi mod add mod_name repo_name "mod_description"
'

# List all available recipes
@_default:
  just --justfile {{source_file()}} --list

# TL;DR; See usage examples and quick tips
@tldr:
  echo "{{tldr_info}}"

# Add a module pointing to the justfile in the repo
[unix]
@add name repo_name description:
  #!/usr/bin/env sh
  repo_dir={{hi_github_base_dir}}/{{repo_name}}
  line1="# {{description}}"
  line2="mod? {{name}} '$repo_dir/justfile'"

  echo "Justfile: {{user_justfile}}"

  if [ ! -d $repo_dir ]; then
    just repo clone {{repo_name}}
  else
    echo "Repo already exists. Skipping."
  fi
  if [ ! -d $repo_dir ]; then
    echo "ERROR Unable to find local copy of repository."
    exit 0
  fi
  if [ -f {{user_justfile}} ]; then
    echo "Adding module to justfile at {{user_justfile}}"
    if ! grep -q "^$line2\$" {{user_justfile}}; then
        printf "\n" >> {{user_justfile}}
        echo $line1 >> {{user_justfile}}
        echo $line2 >> {{user_justfile}}
        echo "Added module definition to {{user_justfile}}"
    else
      echo "Module already registerd in {{user_justfile}}. Skipping."
    fi
  else
      echo "Unable to find {{user_justfile}} file."
      echo "Add the definition manually"
      echo $line1
      echo $line2
  fi