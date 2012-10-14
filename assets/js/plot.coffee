define [], () ->
	# plot x/y value pairs on a canvas element
	plot2d = (canvas, xValues, yValues, options) ->
		ctx = canvas.getContext "2d"
		if options?.modifyContext?
			options.modifyContext(ctx)
		ctx.beginPath()
		yOffset = canvas.height / 2
		i = 0
		ctx.moveTo xValues[i], yOffset - yValues[i]
		for x, i in xValues
			displayY = yOffset - yValues[i]
			ctx.lineTo x, displayY
		ctx.stroke()

	{
		plot2d
	}
