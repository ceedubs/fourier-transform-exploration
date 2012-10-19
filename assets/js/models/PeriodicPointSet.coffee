define ['backbone', 'models/PointSet', 'models/Point2d'], (Backbone, PointSet, Point2d) ->
	class PeriodicPointSet extends Backbone.Model
		defaults:
			singlePeriodPoints: new PointSet()
			periodCount: 2

		initialize: ->
			@set "points", new PointSet
			@recalculatePoints()
			(@get "singlePeriodPoints").on "all", @recalculatePoints
			@on "change:periodCount change:singlePeriodPoints", @recalculatePoints

		recalculatePoints: =>
			singlePeriodPoints = (@get "singlePeriodPoints")
			pointCount = singlePeriodPoints.length
			firstPoint = singlePeriodPoints.at 0
			lastPoint = singlePeriodPoints.at pointCount - 1
			period = (lastPoint.get "x") - (firstPoint.get "x")
			newPoints = []
			for i in [0..(@get "periodCount") - 1]
					singlePeriodPoints.forEach (point, singlePeriodIndex) ->
						newPointIndex = i * period + singlePeriodIndex
						newPoints[newPointIndex] = new Point2d
							x: i * period + (point.get "x")
							y: point.get "y"
			(@get "points").reset newPoints
