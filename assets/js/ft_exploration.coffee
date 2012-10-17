require ['models/SquareWave', 'models/PointSet', 'views/PlotView', 'models/DftPointSet', 'views/FourierSeriesWaveEditorView'], (SquareWave, PointSet, PlotView, DftPointSet, FourierSeriesWaveEditorView) ->
	# when page loads
	numCoefs = 35 # arbitrary - eventually there will be a control to adjust this

	plot = document.getElementById "ft-exploration-canvas"
	squareWave = new SquareWave
		amplitude: plot.height / 2 * 0.75
		period: plot.width / 3
		xValues: [0..plot.width]
		plotColor: "black"
		plotLineWidth: 1

	recreatedSquareWave = new DftPointSet
		emulationPointSet: squareWave
		plotColor: "rgba(0, 0, 256, .25)"
		plotLineWidth: 3

	$editorForm = $ "#wave-editor-form"
	recreatedSquareWaveEditorView = new FourierSeriesWaveEditorView
		el: $editorForm
		model: recreatedSquareWave
	recreatedSquareWaveEditorView.render()
		
	plotView = new PlotView
		el: plot
		collection: new Backbone.Collection [squareWave, recreatedSquareWave]
	plotView.render()
