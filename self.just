default_justfile_content := "# DEFAULT JUSTFILE FOR CUSTOMIZATIONS
  
# Greet anyone!
@greet who='World':
  echo 'Hello {{who}}!'

# Edit user default hi.justfile
[windows]
@edit-justfile:
  code {{home_dir()}}\\.config\\hi\\hi.justfile

# Edit user default hi.justfile
[unix]
@edit-justfile:
  vim ~/.config/hi/hi.justfile
"

@_default:
  just --justfile {{source_file()}} --list --unsorted

# Create user default hi.justfile
[windows]
init:
  #!pwsh.exe
  $justfile="~/.config/hi/hi.justfile"
  if (Test-Path -Path $justfile) {
    echo "Default hi.justfile already exists: $justfile"
  } else {
    $justfileDir = Split-Path -Path $justfile
    if (-Not (Test-Path -Path $justfileDir)) {
      New-Item -Path $justfileDir -ItemType Directory -Force
    }
    New-Item -Path $justfile -ItemType File -Force
    "{{default_justfile_content}}" | Out-File $justfile 
    echo "Created $justfile"
  }

# Create user default hi.justfile
[unix]
init:
  #!/usr/bin/env sh
  justfile=~/.config/hi/hi.justfile
  if [ ! -f $justfile ]; then
    mkdir -p "$(dirname $justfile)" && touch $justfile
    echo "{{default_justfile_content}}" > $justfile
    echo "Created justfile: $justfile"
  else
    echo "Default hi.justfile already exists: $justfile"
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
