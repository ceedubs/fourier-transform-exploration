define ['backbone', 'models/Point2d', 'models/PointSet', 'signal'], (Backbone, Point2d, PointSet, signal) ->
	flatMap = _.compose(((l) -> _.flatten(l, true)), _.map)
	class DiscreteFourierSeries extends Backbone.Model
		defaults:
			termsCount: 10

		initialize: ->
			@set "points", new PointSet
			(@get "emulationPointSet").on "all", @recalculatePoints
			@on "change:termsCount", @recalculatePoints
			@recalculatePoints()

		recalculatePoints: =>
			emuPointSet = @get "emulationPointSet"
			newXValues = flatMap emuPointSet.models, (point) -> point.get "x"
			newEmuYValues = flatMap emuPointSet.models, (point) -> point.get "y"
			dftCoefs = signal.dft (newEmuYValues), (@get "termsCount")
			newYValues = signal.inverseDft dftCoefs, newXValues
			(@get "points").reset _.map(_.zip(newXValues, newYValues), (point) ->
				[x, y] = point
				new Point2d
					x: x
					y: y
			)
