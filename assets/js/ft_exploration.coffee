require ['models/SquareWave', 'models/PlotPointSet', 'views/PlotView', 'models/DiscreteFourierSeries', 'views/FourierSeriesWaveEditorView', 'models/PeriodicPointSet'], (SquareWave, PlotPointSet, PlotView, DiscreteFourierSeries, FourierSeriesWaveEditorView, PeriodicPointSet) ->
	# when page loads
	numCycles = 3

	plot = document.getElementById "ft-exploration-canvas"
	period = plot.width / numCycles
	squareWave = new SquareWave
		period: period
		xValues: (x for x in [0..period])

	recreatedSquareWave = new DiscreteFourierSeries
		emulationPointSet: squareWave.get "points"

	$editorForm = $ "#wave-editor-form"
	recreatedSquareWaveEditorView = new FourierSeriesWaveEditorView
		el: $editorForm
		model: recreatedSquareWave
	recreatedSquareWaveEditorView.render()

	fullSquareWave = new PeriodicPointSet
		singlePeriodPoints: squareWave.get "points"
		periodCount: numCycles

	fullRecreatedSquareWave = new PeriodicPointSet
		singlePeriodPoints: recreatedSquareWave.get "points"
		periodCount: numCycles
		
	plotView = new PlotView
		el: plot
		collection: new Backbone.Collection [
			new PlotPointSet
				points: fullSquareWave.get "points"
				color: "black"
				lineWidth: "1"
			new PlotPointSet
				points: fullRecreatedSquareWave.get "points"
				color: "rgba(0, 0, 256, .25)"
				lineWidth: 3
		]
	plotView.render()
