define ['backbone', 'underscore', 'models/Point2d'], (Backbone, _, Point2d) ->
	flatMap = _.compose(((l) -> _.flatten(l, true)), _.map)
	linearScale = (params) ->
		oldRange = params.oldMax - params.oldMin
		newRange = params.newMax - params.newMin
		(x) ->
			(x - params.oldMin) * newRange / oldRange

	class PlotView extends Backbone.View
		tagName: "canvas"

		initialize: ->
			@collection.on "all", @render

		render: =>
			allXs = flatMap @collection.models, (plotPointSet) ->
				pointSet = plotPointSet.get "points"
				flatMap pointSet.models, (point) -> point.get "x"
			allYs = flatMap @collection.models, (plotPointSet) ->
				pointSet = plotPointSet.get "points"
				flatMap pointSet.models, (point) -> point.get "y"
			[minX, maxX] = [_.min(allXs), _.max(allXs)]
			[minY, maxY] = [_.min(allYs), _.max(allYs)]
			xPixelCount = @el.width
			yPixelCount = @el.height
			yScaleFactor = @options.yScaleFactor ? .9
			toXPixel = linearScale
				oldMin: minX
				oldMax: maxX
				newMin: 0
				newMax: xPixelCount
			newYMin = (1 - yScaleFactor) * yPixelCount
			yScale = linearScale
				oldMin: minY
				oldMax: maxY
				newMin: newYMin 
				newMax: yScaleFactor * yPixelCount
			toYPixel = (y) ->
				yPixelCount - (newYMin + yScale(y))
				
			ctx = @el.getContext "2d"
			ctx.clearRect 0, 0, @el.width, @el.height
			@collection.each (plotPointSet) =>
				pointSet = plotPointSet.get "points"
				displayPoints = pointSet.map (point2d) ->
					new Point2d
						x: toXPixel(point2d.get "x")
						y: toYPixel(point2d.get "y")

				ctx.strokeStyle = plotPointSet.get "color"
				ctx.lineWidth = plotPointSet.get "lineWidth"
				ctx.beginPath()
				firstPoint = displayPoints[0]
				ctx.moveTo((firstPoint.get "x"), (firstPoint.get "y"))
				_.forEach displayPoints, (point) ->
					ctx.lineTo((point.get "x"), (point.get "y"))
				ctx.stroke()
			@
