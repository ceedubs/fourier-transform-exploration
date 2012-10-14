fs = require 'fs'

{print} = require 'sys'
{exec, spawn} = require 'child_process'
{copy}  = require 'fs-extra'

cpPublic = (callback) ->
	copy 'public', '_site', (err) ->
		if err
			process.stderr.write err
		else
			callback?()

build = (callback) ->
	cpPublic () ->
		coffee = spawn 'coffee', ['-c', '-o', '_site/js', 'assets/js']
		coffee.stderr.on 'data', (data) ->
			process.stderr.write data.toString()
		coffee.stdout.on 'data', (data) ->
			print data.toString()
		coffee.on 'exit', (code) ->
			callback?() if code is 0

task 'build', 'Build _site/lib from src/', ->
	build()

task 'watch', 'Watch src/ for changes', ->
	cpPublic () ->
		coffee = spawn 'coffee', ['-w', '-c', '-o', '_site/js', 'assets/js']
		coffee.stderr.on 'data', (data) ->
				process.stderr.write data.toString()
		coffee.stdout.on 'data', (data) ->
				print data.toString()
