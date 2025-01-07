main_justfile_content := "# MAIN JUSTFILE FOR USER CUSTOMIZATIONS
  
# Greet anyone!
@greet who='World':
  echo 'Hello {{who}}!'

# Edit user main.justfile
[windows]
@edit-justfile:
  code {{home_dir()}}/.config/hi/main.justfile

# Edit user main.justfile
[unix]
@edit-justfile:
  vim {{home_dir()}}/.config/hi/main.justfile
"

main_justfile_path := "$HOME/.config/hi/main.justfile"

@_default:
  just --justfile {{source_file()}} --list --unsorted

# Create user main.justfile
[windows]
init:
  #!pwsh.exe
  if (Test-Path -Path {{main_justfile_path}}) {
    echo "main.justfile already exists: {{main_justfile_path}}"
  } else {
    $justfileDir = Split-Path -Path {{main_justfile_path}}
    if (-Not (Test-Path -Path $justfileDir)) {
      New-Item -Path $justfileDir -ItemType Directory -Force
    }
    New-Item -Path {{main_justfile_path}} -ItemType File -Force
    "{{main_justfile_content}}" | Out-File {{main_justfile_path}}
    echo "Created {{main_justfile_path}}"
  }

# Create user main.justfile
[unix]
init:
  #!/usr/bin/env sh
  # justfile=~/.config/hi/hi.justfile
  if [ -f {{main_justfile_path}} ]; then
    echo "main.justfile already exists: {{main_justfile_path}}"
  else
    mkdir -p "$(dirname {{main_justfile_path}})" && touch {{main_justfile_path}}
    echo "{{main_justfile_content}}" > {{main_justfile_path}}
    echo "Created justfile: {{main_justfile_path}}"
  fi

# Output the directory where the hi source live
@dir:
  echo {{justfile_directory()}}

# Open hi source directory in vscode
[windows]
@edit:
  code {{source_directory()}}

# Open hi source directory in vim
[unix]
@edit:
  vim {{source_directory()}}

# Update the local hi repo to the lastest version
@update:
  git pull --rebase

alias up := update

# Save (commit) any changes to the local hi repo
@commit message:
  git status && git add . && git commit -m "{{message}}"

# Push changes to the remote hi repo
@push:
  git push

# Commit any changes and push to remote dotfiles repo
@commitpush message:
  git status && git add . && git commit -m "{{message}}" && git push

alias cmp := commitpush

# See the status of the local dotfiles repo
@status:
  git status

alias st := status

# See the diff of the local dotfiles repo
@diff:
  git diff

# See the history of the local dotfiles repo
@log *args:
  git log --graph --pretty=format:'%Cred%h%Creset %ad -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short {{args}}

# Publish a new version of hi
@publish version notes:
  echo '🚧 Not yet implemented.'
  echo 'Publishing version: {{version}}...\n  with notes: {{notes}}'
  echo 'TODO: mark a tag and create a release on github?'
  exit 1
