function Get-EnvVar {
    param (
        [string]$VarName,          # Name of the environment variable
        [string]$DefaultValue      # Default value to return if the environment variable is not set
    )
    
    if (Test-Path env:$VarName) {
        return [Environment]::GetEnvironmentVariable($VarName)
    } else {
        return $DefaultValue
    }
}

function Install-If-Not-Exists() {
    param (
        [string]$Command,        # Command to check for
        [string]$Package         # WinGet package to install if command is not found
    )

    if (Get-Command -ErrorAction SilentlyContinue $Command) {
        Write-Output "$Command was found, skipping"
    } else {
        Write-Output "$Command not found, installing $Package"
        winget install $Package
    }
}

function Add-Content-If-Not-Exists() {
    param (
        [string]$Path,
        [string]$Value
    )

    if (-not (Get-Content $Path | Select-String -Pattern [regex]::Escape($Value))) {
        # If the string is not found, append it to the file
        Add-Content -Path $filePath -Value $stringToWrite
        Write-Output "String added to the file."
    } else {
        Write-Output "String already exists in the file."
    }
}

$hi_function_def = @"
# BEGIN HI ALIAS FOR JUST
# This was added by the hi install script. Do not edit.
function hi() {
    just --shell "pwsh.exe" --shell-arg -c --justfile `${HOME}/hi/github.com/rudylattae/hi/justfile $args
}
# END HI ALIAS FOR JUST
"@


# Install `git` and `just` if they are not found
Write-Output "Installing git and just..."
Install-If-Not-Exists "git" "Git.Git"
Install-If-Not-Exists "just" "Casey.Just"

# Clone hi to `$HI_CLONE_BASE_DIR/github.com/rudylattae/hi`
# if `$HI_CLONE_BASE_DIR` is not set, it defaults to`$HOME/hi`
# Cloning will only happen if that target directory for the repo does not already exist
Write-Output "Cloning rudylattae/hi..."
$hi_clone_base_dir = Get-EnvVar "HI_CLONE_BASE_DIR" "$HOME/hi"
$hi_github_base_dir = "$hi_clone_base_dir/github.com"
$hi_repo_dir = "$hi_github_base_dir/rudylattae/hi"
$hi_repo_url = "git@github.com:rudylattae/hi.git"
if (Test-Path $hi_repo_dir) {
    Write-Output "$hi_repo_dir already exists, `hi` will not be cloned"
} else {
    Write-Output "Cloning $hi_repo_url to $hi_repo_dir"
    git clone $hi_repo_url $hi_repo_dir
}

Write-Output "Registering hi alias for just in profile..."
if (Test-Path $PROFILE) {
    Add-Content-If-Not-Exists $PROFILE $hi_function_def
    Write-Host "Registered alias in $PROFILE"
} else {
    Write-Host "No profile found at $PROFILE. You must have one before the alias can be added"
}