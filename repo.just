hi_clone_base_dir := absolute_path(env('HI_CLONE_BASE_DIR', append('/hi', home_dir())))
hi_github_base_dir := absolute_path(append('/github.com', hi_clone_base_dir))

tldr_info := '# Use cases

## Clone a repository from github
Clone a repo providing the github repository path <repo_name> in the format user/repo or org/repo.
Where ""user"" is the github username or ""org"" is the organization name.
If a local directory for the repository already exists, it will not be cloned.

> ... repo clone <repo_name>

Examples:
> ... repo clone rudylattae/hi


## Open the repo directory in VSCode

> ... repo code <repo_name>

Examples:
> ... repo code rudylattae/hi


## Get the location of a repo_name
Output the directory where a repo_name:
  if  is stored

> ... repo dir <repo_name>

Examples:
> ... repo dir rudylattae/hi
'


@_default:
  just --justfile {{source_file()}} --list


# TL;DR; See usage examples and quick tips
@tldr:
  echo "{{tldr_info}}"


# Clone the <repo_name> into local directory (WINDOWS)
[windows]
@clone repo_name:
  #!pwsh.exe
  $repo_url = "git@github.com:{{repo_name}}.git"
  $repo_dir = "{{hi_github_base_dir}}/{{repo_name}}"
  if (Test-Path -Path $repo_dir) {
    echo "Local directory $repo_dir already exists. Will not clone. Try updating the repo instead."
  } else {
    echo "Cloning $repo_url to $repo_dir"
    git clone $repo_url $repo_dir
  }

# Clone the <repo_name> into local directory (UNIX)
[unix]
@clone repo_name:
  #!/usr/bin/env bash
  repo_url="git@github.com:{{repo_name}}.git"
  repo_dir="{{hi_github_base_dir}}/{{repo_name}}"
  if [ ! -d $repo_dir ]; then
    echo "Cloning $repo_url to $repo_dir"
    git clone $repo_url $repo_dir
  else
    echo "Repo {{repo_name}} already exists at $repo_dir"
  fi

# Open <repo_name> directory for edit in vscode
@code repo_name:
  code "{{hi_github_base_dir}}/{{repo_name}}"


# Update the local <repo_name> to the lastest version (pull+rebase)
@update repo_name:
  cd "{{hi_github_base_dir}}/{{repo_name}}" && git pull --rebase

alias up := update


# See the status of the local <repo_name>
@status repo_name:
  cd "{{hi_github_base_dir}}/{{repo_name}}" && git status

alias st := status


# See the history of the local <repo_name>
@log repo_name *args:
  cd "{{hi_github_base_dir}}/{{repo_name}}" && git log --graph --pretty=format:'%Cred%h%Creset %ad -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short {{args}}


# See the diff of the local <repo_name>
@diff repo_name:
  cd "{{hi_github_base_dir}}/{{repo_name}}" && git diff


# Commit any changes and push to remote <repo_name>
@commitpush repo_name message:
  cd "{{hi_github_base_dir}}/{{repo_name}}" && git status && git add . && git commit -m "{{message}}" && git push

alias cmp := commitpush


# Output the <repo_name> location on disk
@dir repo_name:
  echo "{{hi_github_base_dir}}/{{repo_name}}"


# Check if a repo exists locally
[unix]
@exists repo_name:
  if [ -d {{hi_github_base_dir}}/{{repo_name}} ]; then echo "yes"; else echo "no"; fi

# Check if a repo exists locally
[windows]
@exists repo_name:
  #!pwsh.exe
  $repo_dir = "{{hi_github_base_dir}}/{{repo_name}}"
  if (Test-Path -Path $repo_dir) {
    echo "yes"
  } else {
    echo "no"
  }


# Output the on disk repositories 
[windows]
@list:
  #!pwsh.exe
  $repo_dir = "{{hi_github_base_dir}}"
  Get-ChildItem -Path $repo_dir -Directory -Recurse -Depth 1 | 
    ForEach-Object {
        "$($_.Parent.Name)/$($_.Name)"
    }

[unix]
@list:
  #!/usr/bin/env bash
  repo_dir="{{hi_github_base_dir}}"
  find "$repo_dir" -mindepth 2 -maxdepth 2 -type d | awk -F/ '{if (NF>1) print $(NF-1)"/"$NF}'
  
alias ls := list
