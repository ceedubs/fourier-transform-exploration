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

sign = (x) -> if x >= 0 then 1 else -1

squareWave = (xValues, amplitude, period) ->
	(amplitude * sign Math.sin(2 * Math.PI * x / period) for x in xValues)

dft = (values) ->
	numPoints = values.length
	realCoefs = []
	imaginaryCoefs = []
	w0 = 2 * Math.PI / numPoints # fundamental angular frequency (omega naught)
	for k in [0...numPoints]
		realCoef = imaginaryCoef = 0
		wk = w0 * k # base frequency for this value of k
		for y, i in values
			theta = wk * i
			realCoef += y * Math.cos(theta)
			imaginaryCoef += y * -1 * Math.sin(theta)
		realCoefs[k] = realCoef
		imaginaryCoefs[k] = imaginaryCoef

	{ real: realCoefs, imaginary: imaginaryCoefs }

inverseDft = (realFtCoefs, imaginaryFtCoefs, xValues) ->
	numCoefs = realFtCoefs.length
	realVals = []
	imaginaryVals = []
	for x, i in xValues
		realValAtX = 0
		imaginaryValAtX = 0
		w0x = 2 * Math.PI * x / numCoefs
		for k in [0...numCoefs]
			theta = w0x * k
			realValAtX += realFtCoefs[k] * Math.cos theta
			imaginaryValAtX -= imaginaryFtCoefs[k] * Math.sin theta

		# normalize
		realVals[i] = realValAtX / numCoefs
		imaginaryVals[i] = imaginaryValAtX / numCoefs
	{ real: realVals, imaginary: imaginaryVals }
		

# when page loads
canvas = document.getElementById "ft-exploration-canvas"
if canvas.getContext?
	amplitude = canvas.height / 2 * 0.9
	period = canvas.width / 3
	xValues = [0..canvas.width]
	yValues = squareWave xValues, amplitude, period
	plot2d canvas, xValues, yValues, {
		modifyContext: (ctx) ->
			ctx.lineWidth = 1
			ctx.strokeStyle = "black"
	}
	squareDft = dft yValues
	numCoefs = xValues.length
	realCoefs = squareDft.real[0...numCoefs]
	imaginaryCoefs = squareDft.imaginary[0...numCoefs]
	recreatedSquareVals = inverseDft realCoefs, imaginaryCoefs, xValues
	plot2d canvas, xValues, recreatedSquareVals.imaginary, {
		modifyContext: (ctx) ->
			ctx.lineWidth = 4
			ctx.strokeStyle = "rgba(256, 0, 0, .25)"
	}
	plot2d canvas, xValues, recreatedSquareVals.real, {
		modifyContext: (ctx) ->
			ctx.lineWidth = 4
			ctx.strokeStyle = "rgba(0, 0, 256, .25)"
	}
