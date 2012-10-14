require ['models/SquareWave', 'models/PointSet', 'views/PlotView', 'signal'], (SquareWave, PointSet, PlotView, signal) ->
	# when page loads
	numCoefs = 35 # arbitrary - eventually there will be a control to adjust this

	plot = document.getElementById "ft-exploration-canvas"
	squareWave = new SquareWave
		amplitude: plot.height / 2 * 0.75
		period: plot.width / 3
		xValues: [0..plot.width]
		plotColor: "black"
		plotLineWidth: 1

	calculateRecreatedSquareWave = () ->
		squareDftComplexCoefs = signal.dft squareWave.yValues(), numCoefs
		signal.inverseDft squareDftComplexCoefs, squareWave.xValues()

	recreatedSquareWave = new PointSet
		xValues: squareWave.xValues()
		yValues: calculateRecreatedSquareWave()
		plotColor: "rgba(0, 0, 256, .25)"
		plotLineWidth: 3

	squareWave.on "change:yValues", () ->
		recreatedSquareWave.set "yValues", calculateRecreatedSquareWave()
		
	plotView = new PlotView
		el: plot
		collection: new Backbone.Collection [squareWave, recreatedSquareWave]
	plotView.render()
