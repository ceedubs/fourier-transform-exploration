define ['backbone', 'models/PointSet', 'signal'], (Backbone, PointSet, signal) ->
	class DftPointSet extends PointSet
		defaults:
			termsCount: 10

		initialize: ->
			emuPointSet = @get "emulationPointSet"
			emuPointSet.on "change:xValues change:yValues", @recalculate
			@on "change:termsCount", @recalculate
			@recalculate()

		recalculate: ->
			emuPointSet = @get "emulationPointSet"
			newXValues = emuPointSet.get "xValues"
			dftCoefs = signal.dft (emuPointSet.get "yValues"), (@get "termsCount")
			newYValues = signal.inverseDft dftCoefs, newXValues
			@set
				xValues: newXValues
				yValues: newYValues
			@
