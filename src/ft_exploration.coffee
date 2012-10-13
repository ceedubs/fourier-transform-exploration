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

sign = (x) -> if x >= 0 then 1 else -1

squareWave = (xValues, amplitude, period, phase = 0) ->
	(amplitude * sign Math.sin(2 * Math.PI * x / period + phase) for x in xValues)

class Complex
	constructor: (@real, @imaginary) ->

dft = (values) ->
	numPoints = values.length
	coefs = []
	w0 = 2 * Math.PI / numPoints # fundamental angular frequency (omega naught)
	for k in [0...numPoints]
		realCoef = imaginaryCoef = 0
		wk = w0 * k # base frequency for this value of k
		for y, i in values
			theta = wk * i
			realCoef += y * Math.cos(theta)
			imaginaryCoef += y * -1 * Math.sin(theta)
		coefs[k] = new Complex realCoef, imaginaryCoef

	coefs

inverseDft = (complexCoefs, xValues) ->
	numCoefs = complexCoefs.length
	numXValues = xValues.length
	output = []
	for x, i in xValues
		realValAtX = 0
		imaginaryValAtX = 0
		w0x = 2 * Math.PI * x / numXValues
		for complexCoef, k in complexCoefs
			theta = w0x * k
			realValAtX += complexCoef.real * Math.cos theta
			imaginaryValAtX -= complexCoef.imaginary * Math.sin theta

		# normalize
		output[i] = 2 / numXValues * (realValAtX + imaginaryValAtX)
	output
		

# when page loads
canvas = document.getElementById "ft-exploration-canvas"
if canvas.getContext?
	amplitude = canvas.height / 2 * 0.75
	period = canvas.width / 3
	xValues = [0..canvas.width]
	yValues = squareWave xValues, amplitude, period
	plot2d canvas, xValues, yValues, {
		modifyContext: (ctx) ->
			ctx.lineWidth = 1
			ctx.strokeStyle = "black"
	}
	squareDftComplexCoefs = dft yValues
	numCoefs = 40 # arbitrary - eventually there will be a control to adjust this
	recreatedSquareVals = inverseDft squareDftComplexCoefs[0...numCoefs], xValues
	plot2d canvas, xValues, recreatedSquareVals, {
		modifyContext: (ctx) ->
			ctx.lineWidth = 4
			ctx.strokeStyle = "rgba(256, 0, 0, .25)"
	}
