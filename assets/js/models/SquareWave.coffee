define ['backbone', 'models/PointSet', 'models/Point2d'], (Backbone, PointSet, Point2d) ->
	class SquareWave extends Backbone.Model
		defaults:
			phase: 0
			amplitude: 1

		initialize: () ->
			@set "points", new PointSet
			@updatePoints()
			@on "change:amplitude change:period change:phase change:xValues", @updatePoints

		updatePoints: () =>
			xValues = @get "xValues"
			(@get "points").reset _.map(xValues, (x) =>
				new Point2d
					x: x
					y: @_calculateYValue x
			)
			@

		_calculateYValue: (x) =>
			sign = (x) -> if x >= 0 then 1 else -1
			(@get "amplitude") * sign Math.sin(2 * Math.PI * x / (@get "period") + (@get "phase"))
