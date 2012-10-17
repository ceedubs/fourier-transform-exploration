fs = require 'fs-extra'
glob = require 'glob'
hogan = require 'hogan.js'
requirejs = require 'requirejs'
path = require 'path'
async = require 'async'
_ = require 'underscore'
{print} = require 'sys'
{exec, spawn} = require 'child_process'

appConfig =
	siteDir: '_site'
	siteContentDirs: ['html', 'css', 'js']
	publicDir: 'public'
	jsAssetsRoot: 'assets/js'
	templateSrcDir: 'assets/templates'

writeFile = (fileName, fileContents, cb) ->
	async.series [
		(cb) -> fs.mkdirp(path.dirname(fileName), cb)
		(cb) -> fs.writeFile fileName, fileContents, cb
	], cb

cpPublic = (callback) ->
	fs.copy appConfig.publicDir, appConfig.siteDir, callback

clearSiteDir = (callback) ->
	dirsToRemove = ("#{appConfig.siteDir}/#{dir}" for dir in appConfig.siteContentDirs)
	async.forEach(dirsToRemove, (dir, cb) ->
		fs.remove dir, cb
	, callback)

compileTemplates = (srcDir, destDir, callback) ->
	templateExtension = ".mustache"
	compiledTemplateExtension = ".js"

	getTemplateFileNames = (cb) ->
		glob "#{srcDir}/**/*#{templateExtension}", {}, cb
	
	getDestinationFile = (fileName) ->
		relativePath = path.relative srcDir, fileName
		relativeDirPath = path.dirname relativePath
		withoutExtension = path.basename relativePath, templateExtension
		"#{destDir}/#{relativeDirPath}/#{withoutExtension}#{compiledTemplateExtension}"

	async.waterfall [
		getTemplateFileNames
		# filename -> file info including the content of the file
		(fileNames, cb) ->
			async.map fileNames, (fileName, fileCb) ->
				fs.readFile fileName, 'utf8', (err, fileContent) ->
					fileCb err, {
						fileName
						destFile: getDestinationFile fileName
						content: fileContent
					}
			, cb
		# file info -> file info with a compiled hogan template
		(files, cb) ->
			filesWithCompiledTemplate = _.map files, (file) ->
				compiledTemplate = hogan.compile file.content, { asString: true }
				output = "define(['hogan'],function(Hogan){return new Hogan.Template(#{compiledTemplate});})"
				{
					fileName: file.fileName
					destFile: file.destFile
					compiledTemplate: output
				}
			cb null, filesWithCompiledTemplate
		# write the compiled templates to files
		(files, cb) ->
			async.forEach files, (file, fileCallback) ->
				writeFile file.destFile, file.compiledTemplate, fileCallback
			, cb
	], callback
	
compileCoffee = (srcDir, destDir, callback) ->
		coffee = spawn 'coffee', ['-c', '-o', destDir, srcDir]
		coffee.stderr.on 'data', (data) ->
			process.stderr.write data.toString()
		coffee.stdout.on 'data', (data) ->
			print data.toString()
		coffee.on 'exit', (code) ->
			err = if code is 0 then null else new Error "CoffeeScript compile step failed"
			callback? err

build = (callback) ->
	tempCompileDir = '_site/_temp'
	tempJsCompileDir = "#{tempCompileDir}/js"
	templateDestDir = tempJsCompileDir + '/templates'

	cleanupTempDir = (cb) ->
		fs.remove tempCompileDir, cb

	cleanAndFinish = (err) ->
		cleanupTempDir (cleanupErr) ->
			callback err, cleanupErr

	compileCsToTemp = (cb) ->
		compileCoffee appConfig.jsAssetsRoot, tempJsCompileDir, cb

	compileTemplatesToTemp = (cb) ->
		compileTemplates(appConfig.templateSrcDir, templateDestDir, cb)

	optimizeJs = (cb) ->
		rjsConfig =
			optimize: 'none'
			baseUrl: tempJsCompileDir
			name: 'ft_exploration'
			out: '_site/js/ft_exploration.js'
			paths:
				'backbone': 'empty:'
				'underscore': 'empty:'
				'hogan': 'empty:'
		requirejs.optimize rjsConfig, (buildResponse) ->
			cb?()

	async.auto({
		clearSiteDir
		cpPublic: ['clearSiteDir', cpPublic]
		compileCsToTemp: ['clearSiteDir', compileCsToTemp]
		compileTemplatesToTemp: ['clearSiteDir', compileTemplatesToTemp]
		optimizeJs: [
			'cpPublic'
			'compileCsToTemp'
			'compileTemplatesToTemp'
			optimizeJs
		]
	}, cleanAndFinish)

task 'build', 'Build _site/lib from src/', ->
	build (err, cleanupErr) ->
		if err? then process.stderr.write err.toString()
		if cleanupErr? then process.stderr.write "Error with cleanup: \n" + cleanupErr.toString()

task 'compile-templates', 'Compile templates', ->
	templateRootDir = "assets/templates"
	compiledTemplateOutDir = ""
	compileTemplates templateRootDir, compiledTemplateOutDir

task 'watch', 'Watch src/ for changes', ->
	cpPublic () ->
		coffee = spawn 'coffee', ['-w', '-c', '-o', '_site/js', 'assets/js']
		coffee.stderr.on 'data', (data) ->
				process.stderr.write data.toString()
		coffee.stdout.on 'data', (data) ->
				print data.toString()
