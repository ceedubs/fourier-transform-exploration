// Generated by CoffeeScript 1.3.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['vendor/backbone', 'plot'], function(Backbone, plot) {
    var PlotView;
    return PlotView = (function(_super) {

      __extends(PlotView, _super);

      function PlotView() {
        this.render = __bind(this.render, this);
        return PlotView.__super__.constructor.apply(this, arguments);
      }

      PlotView.prototype.tagName = "canvas";

      PlotView.prototype.initialize = function() {
        return this.collection.on("change", this.render);
      };

      PlotView.prototype.render = function() {
        var ctx,
          _this = this;
        ctx = this.el.getContext("2d");
        ctx.clearRect(0, 0, this.el.width, this.el.height);
        this.collection.each(function(pointSet) {
          var modifyContext;
          modifyContext = function(ctx) {
            var plotColor, plotLineWidth;
            plotColor = pointSet.get("plotColor");
            if (plotColor != null) {
              ctx.strokeStyle = plotColor;
            }
            plotLineWidth = pointSet.get("plotLineWidth");
            if (plotLineWidth != null) {
              return ctx.lineWidth = plotLineWidth;
            }
          };
          return plot.plot2d(_this.el, pointSet.xValues(), pointSet.yValues(), {
            modifyContext: modifyContext
          });
        });
        return this;
      };

      return PlotView;

    })(Backbone.View);
  });

}).call(this);
