define ['backbone'], (Backbone) ->
	class PointSet extends Backbone.Model
		xValues: () -> @get "xValues"
		yValues: () -> @get "yValues"
