#!/usr/bin/env sh

## Bootstrap an installation of hi onto a fresh machine. 

set -eu

hi_clone_base_dir=${HI_CLONE_BASE_DIR:-~/hi}
hi_github_base_dir="$hi_clone_base_dir/github.com"
hi_repo_name="rudylattae/hi"
hi_repo_dir="$hi_github_base_dir/$hi_repo_name"
hi_repo_url="git@github.com:rudylattae/hi.git"
hi_just_alias="alias hi='just --justfile $hi_repo_dir/justfile \$args'"

log() {
    echo "[$(date -Is)] $*"
}

say() {
  echo "install: $*" >&2
}

err() {
  if [ -n "${td-}" ]; then
    rm -rf "$td"
  fi

  say "error: $*"
  exit 1
}

need() {
  if ! command -v "$1" > /dev/null 2>&1; then
    err "need $1 (command not found)"
  fi
}

download() {
  url="$1"
  output="$2"

  if command -v curl > /dev/null; then
    curl --proto =https --tlsv1.2 -sSfL "$url" "-o$output"
  else
    wget --https-only --secure-protocol=TLSv1_2 --quiet "$url" "-O$output"
  fi
}

command -v curl > /dev/null 2>&1 ||
  command -v wget > /dev/null 2>&1 ||
  err "need wget or curl (command not found)"

need git
need just

if [ -d $hi_repo_dir ]; then
    log "$hi_repo_dir already exists, $hi_repo_name will not be cloned"
else
    log "Cloning $hi_repo_name to $hi_repo_dir..."
    git clone $hi_repo_url $hi_repo_dir
fi

if [ -f ~/.bash_aliases ]; then
    if ! grep -q "^$hi_just_alias\$" ~/.bash_aliases; then
        echo "$hi_just_alias" >> ~/.bash_aliases
        log "Registered alias in "
    fi
else
    log "Unable to find ~/.bash_aliases file."
    log "Add the alias manually"
    log $hi_just_alias
fi