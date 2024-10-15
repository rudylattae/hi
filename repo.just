hi_clone_base_dir := absolute_path(env('HI_CLONE_BASE_DIR', append('/hi', home_dir())))
hi_github_base_dir := absolute_path(append('/github.com', hi_clone_base_dir))

tldr_info := '# Use cases

## Clone a repository from github
Clone a repo providing the github repository path <repo> in the format user/repo or org/repo.
Where ""user"" is the github username or ""org"" is the organization name.
If a local directory for the repo already exists, it will not be cloned.

> ... repo clone <repository>

Examples:
> ... repo clone rudylattae/hi


## Open the repo directory in VSCode

> ... repo code <repository>

Examples:
> ... repo code rudylattae/hi


## Get the location of a repository
Output the directory where a reposiroty is stored

> ... repo dir <repository>

Examples:
> ... repo dir rudylattae/hi
'


@_default:
  just --justfile {{source_file()}} --list


# TL;DR; See usage examples and quick tips
@tldr:
  echo "{{tldr_info}}"


# Clone the <repository> into local directory (WINDOWS)
[windows]
@clone repository:
  #!pwsh.exe
  $repo_url = "git@github.com:{{repository}}.git"
  $repo_dir = "{{hi_github_base_dir}}/{{repository}}"
  if (Test-Path -Path $repo_dir) {
    echo "Local directory $repo_dir already exists. Will not clone. Try updating the repo instead."
  } else {
    echo "Cloning $repo_url to $repo_dir"
    git clone $repo_url $repo_dir
  }

# Clone the <repository> into local directory (UNIX)
[unix]
@clone repository:
  #!/usr/bin/env bash
  repo_url="git@github.com:{{repository}}.git"
  repo_dir="{{hi_github_base_dir}}/{{repository}}"
  echo "Cloning $repo_url to $repo_dir"
  git clone $repo_url $repo_dir


# Open <repository> directory for edit in vscode
@code repository:
  code "{{hi_github_base_dir}}/{{repository}}"


# Update the local <repository> to the lastest version (pull+rebase)
@update repository:
  cd "{{hi_github_base_dir}}/{{repository}}" && git pull --rebase

alias up := update


# See the status of the local <repository>
@status repository:
  cd "{{hi_github_base_dir}}/{{repository}}" && git status

alias st := status


# See the history of the local <repository>
@log repository:
  cd "{{hi_github_base_dir}}/{{repository}}" && git log --graph --pretty=format:'%Cred%h%Creset %ad -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short


# See the diff of the local <repository>
@diff repository:
  cd "{{hi_github_base_dir}}/{{repository}}" && git diff


# Commit any changes and push to remote <repository>
@commitpush repository message:
  cd "{{hi_github_base_dir}}/{{repository}}" && git status && git add . && git commit -m "{{message}}" && git push

alias cmp := commitpush


# Output the <repository> location on disk
@dir repository:
  echo "{{hi_github_base_dir}}/{{repository}}"


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
  find "$repo_dir" -mindepth 1 -maxdepth 1 -type d -printf "%h/%f\n"
  
alias ls := list
