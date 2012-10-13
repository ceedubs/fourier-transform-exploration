fs = require 'fs'

{print} = require 'sys'
{exec, spawn} = require 'child_process'

build = (callback) ->
	coffee = spawn 'coffee', ['-c', '-o', '_site/lib', 'src']
	coffee.stderr.on 'data', (data) ->
		process.stderr.write data.toString()
	coffee.stdout.on 'data', (data) ->
		print data.toString()
	coffee.on 'exit', (code) ->
		callback?() if code is 0

task 'build', 'Build _site/lib from src/', ->
	build()

task 'watch', 'Watch src/ for changes', ->
		coffee = spawn 'coffee', ['-w', '-c', '-o', '_site/lib', 'src']
		coffee.stderr.on 'data', (data) ->
				process.stderr.write data.toString()
		coffee.stdout.on 'data', (data) ->
				print data.toString()

task 'deploy', 'Deploy _site to gh-pages', ->
	siteDir = '_site'
	deployCommitMsg = "Update lib to reflect source changes"
	exec([
		"git add ."
		"git commit -m '#{deployCommitMsg}'"
	].join(' && '), { cwd: siteDir }, (error, stdout, stderr) ->
		print stdout
		exitErrorMsg = "deploy was not necessary or did not complete successfully\n"
		if error
			process.stderr.write stderr.toString()
			print exitErrorMsg
		else
			gitPush = spawn 'git', ['push', '-n', 'origin', 'gh-pages'], { cwd: siteDir }
			gitPush.stdout.pipe process.stdout
			gitPush.stderr.pipe process.stderr
			process.stdin.resume()
			process.stdin.pipe gitPush.stdin
			gitPush.on 'exit', (code) ->
				if code is 0
					print "deploy to gh-pages completed successfully\n"
				else
					print exitErrorMsg
				process.exit code
	)
