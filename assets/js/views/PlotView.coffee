define ['backbone', 'plot'], (Backbone, plot) ->
	class PlotView extends Backbone.View
		tagName: "canvas"

		initialize: ->
			@collection.on "change", @render

		render: () =>
			ctx = @el.getContext "2d"
			ctx.clearRect 0, 0, @el.width, @el.height
			@collection.each (pointSet) =>
				modifyContext = (ctx) ->
					plotColor = pointSet.get "plotColor"
					if plotColor? then ctx.strokeStyle = plotColor
					plotLineWidth = pointSet.get "plotLineWidth"
					if plotLineWidth? then ctx.lineWidth = plotLineWidth
				plot.plot2d @el, pointSet.xValues(), pointSet.yValues(), {
					modifyContext
				}
			@
