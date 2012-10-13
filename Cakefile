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
