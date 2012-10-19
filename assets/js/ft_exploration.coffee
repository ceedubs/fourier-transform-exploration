require ['models/SquareWave', 'models/PlotPointSet', 'views/PlotView', 'models/DiscreteFourierSeries', 'views/FourierSeriesWaveEditorView'], (SquareWave, PlotPointSet, PlotView, DiscreteFourierSeries, FourierSeriesWaveEditorView) ->
	# when page loads
	plot = document.getElementById "ft-exploration-canvas"
	numCycles = 3
	squareWave = new SquareWave
		period: plot.width / numCycles
		xValues: (x for x in [0..plot.width])

	recreatedSquareWave = new DiscreteFourierSeries
		emulationPointSet: squareWave.get "points"

	$editorForm = $ "#wave-editor-form"
	recreatedSquareWaveEditorView = new FourierSeriesWaveEditorView
		el: $editorForm
		model: recreatedSquareWave
	recreatedSquareWaveEditorView.render()
		
	plotView = new PlotView
		el: plot
		collection: new Backbone.Collection [
			new PlotPointSet
				points: squareWave.get "points"
				color: "black"
				lineWidth: "1"
			new PlotPointSet
				points: recreatedSquareWave.get "points"
				color: "rgba(0, 0, 256, .25)"
				lineWidth: 3
		]
	plotView.render()
