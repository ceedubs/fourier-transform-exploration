define ['models/PointSet'], (PointSet) ->
	sign = (x) -> if x >= 0 then 1 else -1

	class SquareWave extends PointSet
		defaults:
			phase: 0

		initialize: () ->
			@_yValues = @_calculateYValues()

		yValues: () -> @_yValues

		_calculateYValues: () ->
			((@get "amplitude") * sign Math.sin(2 * Math.PI * x / (@get "period") + (@get "phase")) for x in (@get "xValues"))
