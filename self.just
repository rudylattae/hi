@_default:
  just --justfile {{source_file()}} --list

# Configure and get going
@bootstrap:
  echo '🚧 Not yet implemented yet' && exit 1

# Output the directory where the hi configurations live
@dir:
  echo {{justfile_directory()}}

# Open dotfiles configuration directory in vscode
[windows]
@edit:
  code {{source_directory()}}

# Open dotfiles configuration directory in vscode
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
