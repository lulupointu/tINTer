import 'package:flutter/material.dart';

class SnapScrollPhysics extends ScrollPhysics {
  final List<double> topChildrenHeight;

  /// topChildHeight is the sum of the height of the top children
  final double topChildHeight;

  SnapScrollPhysics({@required this.topChildrenHeight, ScrollPhysics parent})
      : topChildHeight = topChildrenHeight.fold(0, (previous, current) => previous + current),
        super(parent: parent);

  @override
  SnapScrollPhysics applyTo(ScrollPhysics ancestor) {
    return SnapScrollPhysics(
        parent: buildParent(ancestor), topChildrenHeight: topChildrenHeight);
  }

  double _getPreviousWidgetPixels(ScrollMetrics position) {
    double previousWidgetPixels = 0;
    int widgetIndex = 0;
    double widgetPixels = topChildrenHeight[widgetIndex];
    while (widgetPixels < position.pixels) {
      widgetIndex++;

      previousWidgetPixels = widgetPixels;
      widgetPixels += topChildrenHeight[widgetIndex];
    }
    return previousWidgetPixels;
  }

  double _getNextWidgetPixels(ScrollMetrics position) {
    int widgetIndex = 0;
    double widgetPixels = 0;
    while (widgetPixels < position.pixels) {
      widgetPixels += topChildrenHeight[widgetIndex];

      widgetIndex++;
    }
    return widgetPixels;
  }

  double _getWidgetPixels(ScrollMetrics position) {
    int widgetIndex = 0;
    double widgetPixels = 0;
    double nextWidgetPixels = topChildrenHeight[widgetIndex];
    while (nextWidgetPixels < position.pixels) {
      widgetIndex++;

      widgetPixels = nextWidgetPixels;
      nextWidgetPixels += topChildrenHeight[widgetIndex];
    }

    if (position.pixels - widgetPixels < nextWidgetPixels - position.pixels) {
      return widgetPixels;
    } else {
      return nextWidgetPixels;
    }
  }

  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    if (velocity < -tolerance.velocity)
      return _getPreviousWidgetPixels(position);
    else if (velocity > tolerance.velocity) return _getNextWidgetPixels(position);
    return _getWidgetPixels(position);
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent) ||
        (position.pixels > topChildHeight))
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    return null;
  }

  @override
  ScrollPhysics buildParent(ScrollPhysics ancestor) {
    return super.buildParent(ancestor);
  }

  @override
  bool get allowImplicitScrolling => false;
}
