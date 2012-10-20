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
			@options.rescaleYValues ?= false
			@collection.on "all", @render

		render: =>
			toXPixel = @_xPixelConverter()
			toYPixel = @_yPixelConverter()
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

		_yPixelConverter: =>
			if @_cachedYPixelConverter? and not @options.rescaleYValues
				return @_cachedYPixelConverter
			allYs = flatMap @collection.models, (plotPointSet) ->
				pointSet = plotPointSet.get "points"
				flatMap pointSet.models, (point) -> point.get "y"
			[minY, maxY] = [_.min(allYs), _.max(allYs)]
			yPixelCount = @el.height
			yScaleFactor = @options.yScaleFactor ? .9
			newYMin = (1 - yScaleFactor) * yPixelCount
			yScale = linearScale
				oldMin: minY
				oldMax: maxY
				newMin: newYMin
				newMax: yScaleFactor * yPixelCount
			@_cachedYPixelConverter = (y) ->
				yPixelCount - (newYMin + yScale(y))
				
		_xPixelConverter: =>
			allXs = flatMap @collection.models, (plotPointSet) ->
				pointSet = plotPointSet.get "points"
				flatMap pointSet.models, (point) -> point.get "x"
			[minX, maxX] = [_.min(allXs), _.max(allXs)]
			xPixelCount = @el.width
			linearScale
				oldMin: minX
				oldMax: maxX
				newMin: 0
				newMax: xPixelCount
