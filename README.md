# hi
> A fun little cli companion.
>
> A friendly little cli companion.
> 
> A handy little cli companion.

## Install and bootstrap
### On Windows
hi is an alias to the the [Just task runner](https://just.systems). It uses git to publish and update changes to recipe modules. 

To get it going, you will need to install git, install Just and configure the "hi" alias for your profile. You will need a simple tool to edit your profile and config files.  `VS Code`  or `NotePad++` will do nicely on Windows.

**1. Install prerequisites (git and Just)**
```powershell
> winget install Git.Git Casey.Just Microsoft.VisualStudioCode
```

**2. Clone the hi repo inot ~/bin**
```powershell
cd ~/bin
clone git@github.com:rudylattae/hi.git
```

**3. Configure the alias. **
Add the following function to your PowerShell profile. The function acts as a thin wrapper around just and loads the `main.just` always.

```powershell
# Edit your PowerShell profile
> code $PROFILE
```

```powershell
function hi() {
    just --shell "pwsh.exe" --shell-arg -c --justfile ${HOME}/bin/hi/main.just $args
}
```

### On Linux
> TODO


## Get started
Once `hi` is installed and boostrapped on your machine, run it to see the available recipes
```powershell
> hi
Here is a list of stuff I can assist with
Available recipes:
    self ...      # Manage "hi" itself
```

In this case you see the `self` module which is used to manage `hi` itself. To see what recipes are available in the `self` module do:
```powershel
> hi self
Available recipes:
    bootstrap             # Configure hi and get going
    path                  # Output the directory where hi's justfiles are
    publish version notes # Publish a new version
    push message          # Commit and push any changes
    update                # Update the hi repo to the lastest version
    up                    # alias for `update`
```