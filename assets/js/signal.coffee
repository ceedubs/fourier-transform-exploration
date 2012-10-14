define [], () ->
	sign = (x) -> if x >= 0 then 1 else -1

	squareWave = (xValues, amplitude, period, phase = 0) ->
		(amplitude * sign Math.sin(2 * Math.PI * x / period + phase) for x in xValues)

	class Complex
		constructor: (@real, @imaginary) ->

	dft = (values, numSeriesTerms) ->
		numSeriesTerms ?= values.length
		coefs = []
		w0 = 2 * Math.PI / values.length # fundamental angular frequency (omega naught)
		for k in [0...numSeriesTerms]
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

	{
		squareWave
		Complex
		dft
		inverseDft
	}
