define ['backbone', 'models/PointSet'], (Backbone, PointSet) ->
	class PlotPointSet extends Backbone.Model
		defaults:
			color: "black"
			lineWidth: "1"
			points: new PointSet

		initialize: ->
			(@get "points").on "all", (eventName) =>
				@trigger eventName
