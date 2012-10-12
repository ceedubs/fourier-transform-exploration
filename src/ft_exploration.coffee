plot2d = (canvas, xValues, yValues) ->
	ctx = canvas.getContext "2d"
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

# when page loads
canvas = document.getElementById "ft-exploration-canvas"
if canvas.getContext?
	amplitude = canvas.height / 2 * 0.9
	period = canvas.width / 3
	xValues = [0..canvas.width]
	yValues = squareWave xValues, amplitude, period
	plot2d canvas, xValues, yValues
