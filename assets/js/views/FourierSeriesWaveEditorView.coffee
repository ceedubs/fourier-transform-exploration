define ['backbone', 'jquery', 'templates/FourierSeriesWaveEditor', 'jquery-ui'], (Backbone, jQuery, template) ->
	class FourierSeriesWaveEditorView extends Backbone.View
		initialize: ->
			@model.on "change:termsCount", @updateTermsCountDisplay

		render: =>
			@$el.html(template.render @model.toJSON())
			(@$ ".fourier-series-terms-count-slider").slider
				min: 1
				value: @model.get "termsCount"
				slide: (event, ui) =>
					@model.set "termsCount", ui.value
			@

		updateTermsCountDisplay: =>
			termsCount = @model.get "termsCount"
			(@$ ".fourier-series-terms-count-slider").slider "value", termsCount
			(@$ ".fourier-series-terms-count").text termsCount
			@
