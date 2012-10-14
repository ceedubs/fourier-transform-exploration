// Generated by CoffeeScript 1.3.3
(function() {

  require(['models/SquareWave', 'models/PointSet', 'views/PlotView', 'signal'], function(SquareWave, PointSet, PlotView, signal) {
    var calculateRecreatedSquareWave, numCoefs, plot, plotView, recreatedSquareWave, squareWave, _i, _ref, _results;
    numCoefs = 35;
    plot = document.getElementById("ft-exploration-canvas");
    squareWave = new SquareWave({
      amplitude: plot.height / 2 * 0.75,
      period: plot.width / 3,
      xValues: (function() {
        _results = [];
        for (var _i = 0, _ref = plot.width; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this),
      plotColor: "black",
      plotLineWidth: 1
    });
    calculateRecreatedSquareWave = function() {
      var squareDftComplexCoefs;
      squareDftComplexCoefs = signal.dft(squareWave.yValues(), numCoefs);
      return signal.inverseDft(squareDftComplexCoefs, squareWave.xValues());
    };
    recreatedSquareWave = new PointSet({
      xValues: squareWave.xValues(),
      yValues: calculateRecreatedSquareWave(),
      plotColor: "rgba(0, 0, 256, .25)",
      plotLineWidth: 3
    });
    squareWave.on("change:yValues", function() {
      return recreatedSquareWave.set("yValues", calculateRecreatedSquareWave());
    });
    plotView = new PlotView({
      el: plot,
      collection: new Backbone.Collection([squareWave, recreatedSquareWave])
    });
    return plotView.render();
  });

}).call(this);