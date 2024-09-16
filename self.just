alias up := update

@_default:
  just --justfile {{source_file()}} --list

# Configure hi and get going
@bootstrap:
  

# Update the hi repo to the lastest version
@update:
  git pull --rebase

# Commit and push any changes
@push message:
  git status
  git add .
  git commit -m "{{message}}"
  git push

# Publish a new version
@publish version notes:
  echo 'Publishing version: {{version}}...'
  echo '  with notes: {{notes}}'

# Output the directory where hi's justfiles are
@path:
  echo {{justfile_directory()}}