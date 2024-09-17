@_default:
  just --justfile {{source_file()}} --list

# Output the directory where the hi justfiles are
@path:
  echo {{justfile_directory()}}

# Configure and get going
@bootstrap:
  echo '🚧 Not yet implemented yet' && exit 1

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
@cmpush message:
  git status && git add . && git commit -m "{{message}}" && git push

# See the status of the local dotfiles repo
@status:
  git status

# See the diff of the local dotfiles repo
@diff:
  git diff

# See the history of the local dotfiles repo
@log:
  git log --graph --pretty=format:'%Cred%h%Creset %ad -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short

# Publish a new version of hi
@publish version notes:
  echo '🚧 Not yet implemented.'
  echo 'Publishing version: {{version}}...\n  with notes: {{notes}}'
  echo 'TODO: mark a tag and create a release on github?'
  exit 1
