require ['signal', 'plot'], (signal, plot) ->
	# when page loads
	canvas = document.getElementById "ft-exploration-canvas"
	if canvas.getContext?
		amplitude = canvas.height / 2 * 0.75
		period = canvas.width / 3
		xValues = [0..canvas.width]
		yValues = signal.squareWave xValues, amplitude, period
		plot.plot2d canvas, xValues, yValues, {
			modifyContext: (ctx) ->
				ctx.lineWidth = 1
				ctx.strokeStyle = "black"
		}
		numCoefs = 35 # arbitrary - eventually there will be a control to adjust this
		squareDftComplexCoefs = signal.dft yValues, numCoefs
		recreatedSquareVals = signal.inverseDft squareDftComplexCoefs, xValues
		plot.plot2d canvas, xValues, recreatedSquareVals, {
			modifyContext: (ctx) ->
				ctx.lineWidth = 4
				ctx.strokeStyle = "rgba(256, 0, 0, .25)"
		}
