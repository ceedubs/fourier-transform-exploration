// Generated by CoffeeScript 1.3.3
(function() {

  require(['signal', 'plot'], function(signal, plot) {
    var amplitude, canvas, numCoefs, period, recreatedSquareVals, squareDftComplexCoefs, xValues, yValues, _i, _ref, _results;
    canvas = document.getElementById("ft-exploration-canvas");
    if (canvas.getContext != null) {
      amplitude = canvas.height / 2 * 0.75;
      period = canvas.width / 3;
      xValues = (function() {
        _results = [];
        for (var _i = 0, _ref = canvas.width; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      yValues = signal.squareWave(xValues, amplitude, period);
      plot.plot2d(canvas, xValues, yValues, {
        modifyContext: function(ctx) {
          ctx.lineWidth = 1;
          return ctx.strokeStyle = "black";
        }
      });
      numCoefs = 35;
      squareDftComplexCoefs = signal.dft(yValues, numCoefs);
      recreatedSquareVals = signal.inverseDft(squareDftComplexCoefs, xValues);
      return plot.plot2d(canvas, xValues, recreatedSquareVals, {
        modifyContext: function(ctx) {
          ctx.lineWidth = 4;
          return ctx.strokeStyle = "rgba(256, 0, 0, .25)";
        }
      });
    }
  });

}).call(this);
