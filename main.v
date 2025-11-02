module main

import cli
import os

const version = '0.1.0'

fn main() {
	mut cmd := cli.Command{
		name:        'hi'
		description: 'A little cli companion'
		version:     version
		posix_mode: true
		commands:    [
			cli.Command{
				name:        'version'
				description: 'Show version information'
				execute:     show_version
			},
			cli.Command{
				name:        'repo'
				description: 'Repository management commands'
				posix_mode:  true
				commands:    [
					cli.Command{
						name:        'list'
						description: 'List repositories'
						execute:     list_repos
					},
					cli.Command{
						name:        'clone'
						description: 'Clone a repository'
						execute:     clone_repo
					},
					cli.Command{
						name:        'up'
						description: 'Update repository'
						execute:     update_repo
					},
				]
			},
		]
	}
	cmd.setup()
	cmd.parse(os.args)
}

fn show_version(cmd cli.Command) ! {
	println('${cmd.parent.name} version ${version}')
}

fn list_repos(cmd cli.Command) ! {
	println('Listing repositories...')
	res := os.execute('git remote -v')
	if res.exit_code == 0 {
		println(res.output)
	} else {
		println('Error: Not a git repository')
	}
}

fn clone_repo(cmd cli.Command) ! {
	if cmd.args.len < 1 {
		println('Error: Please provide a repository URL')
		return
	}
	repo_url := cmd.args[0]
	println('Cloning repository: ${repo_url}')
	res := os.execute('git clone ${repo_url}')
	println(res.output)
}

fn update_repo(cmd cli.Command) ! {
	println('Updating repository...')
	res := os.execute('git pull --rebase')
	if res.exit_code == 0 {
		println(res.output)
	} else {
		println('Error: Not a git repository or no remote configured')
	}
}
