import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SnapListView extends ListView {

  SnapListView._({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> keyedChildren = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior
        .manual,
  }) : super(
    key: key,
    scrollDirection: scrollDirection,
    reverse: reverse,
    controller: controller,
    primary: primary,
    physics: SnapScrollPhysics(childrenKeys: [
      for (Widget keyedChild in keyedChildren) keyedChild.key
    ]),
    shrinkWrap: shrinkWrap,
    padding: padding,
    itemExtent: itemExtent,
    addAutomaticKeepAlives: addAutomaticKeepAlives,
    addRepaintBoundaries: addRepaintBoundaries,
    addSemanticIndexes: addSemanticIndexes,
    cacheExtent: cacheExtent,
    children: keyedChildren,
    semanticChildCount: semanticChildCount,
    dragStartBehavior: dragStartBehavior,
    keyboardDismissBehavior: keyboardDismissBehavior,
  );


  SnapListView({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior
        .manual,
  }) : this._(
    key: key,
    scrollDirection: scrollDirection,
    reverse: reverse,
    controller: controller,
    primary: primary,
    shrinkWrap: shrinkWrap,
    padding: padding,
    itemExtent: itemExtent,
    addAutomaticKeepAlives: addAutomaticKeepAlives,
    addRepaintBoundaries: addRepaintBoundaries,
    addSemanticIndexes: addSemanticIndexes,
    cacheExtent: cacheExtent,
    keyedChildren: _getKeyedChildren(children),
    semanticChildCount: semanticChildCount,
    dragStartBehavior: dragStartBehavior,
    keyboardDismissBehavior: keyboardDismissBehavior,
  );

  static List<Widget> _getKeyedChildren(List<Widget> children) {
    List<Widget> keyedChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      keyedChildren.add(
          Container(
            key: GlobalKey(),
            child: children[i],
          )
      );
    }
    return keyedChildren;
  }

}


class SnapListView2 extends StatelessWidget {
  final Key _key;
  final Axis _scrollDirection;
  final bool _reverse;
  final ScrollController _controller;
  final bool _primary;
  final bool _shrinkWrap;
  final EdgeInsetsGeometry _padding;
  final bool _addAutomaticKeepAlives;
  final bool _addRepaintBoundaries;
  final bool _addSemanticIndexes;
  final double _cacheExtent;
  final List<Widget> children;
  final int _semanticChildCount;
  final DragStartBehavior _dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior _keyboardDismissBehavior;
  final SnapScrollPhysics2 snapScrollPhysics = SnapScrollPhysics2();

  SnapListView2({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
  }) :
  _key = key,
  _scrollDirection = scrollDirection,
  _reverse = reverse,
  _controller = controller,
  _primary = primary,
  _shrinkWrap = shrinkWrap,
  _padding = padding,
  _addAutomaticKeepAlives = addAutomaticKeepAlives,
  _addRepaintBoundaries = addRepaintBoundaries,
  _addSemanticIndexes = addSemanticIndexes,
  _cacheExtent = cacheExtent,
  children = children,
  _semanticChildCount = semanticChildCount,
  _dragStartBehavior = dragStartBehavior,
  _keyboardDismissBehavior = keyboardDismissBehavior;

  @override
  Widget build(BuildContext context) {
    List<Widget> keyedChildren = _getKeyedChildren(children);
    List<GlobalKey> childrenKeys = [ for (Widget child in keyedChildren) child.key as GlobalKey];
    snapScrollPhysics.childrenKeys = childrenKeys;

    return ListView(
      key: _key,
      scrollDirection: _scrollDirection,
      reverse: _reverse,
      controller: _controller,
      primary: _primary,
      physics: snapScrollPhysics,
      shrinkWrap: _shrinkWrap,
      padding: _padding,
      addAutomaticKeepAlives: _addAutomaticKeepAlives,
      addRepaintBoundaries: _addRepaintBoundaries,
      addSemanticIndexes: _addSemanticIndexes,
      cacheExtent: _cacheExtent,
      children: keyedChildren,
      semanticChildCount: _semanticChildCount,
      dragStartBehavior: _dragStartBehavior,
      keyboardDismissBehavior: _keyboardDismissBehavior,
    );
  }


  List<Widget> _getKeyedChildren(List<Widget> children) {
    List<Widget> keyedChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      keyedChildren.add(
          Container(
            key: GlobalKey(),
            child: children[i],
          )
      );
    }
    return keyedChildren;
  }
}



class SnapScrollPhysics extends ScrollPhysics {
  static List<GlobalKey> childrenKeys;

  SnapScrollPhysics({
    @required List<GlobalKey> childrenKeys,
    ScrollPhysics parent
  }) : super(parent: parent) {
    SnapScrollPhysics.childrenKeys = childrenKeys;
  }

  @override
  SnapScrollPhysics applyTo(ScrollPhysics ancestor) {
    return SnapScrollPhysics(parent: buildParent(ancestor), childrenKeys: childrenKeys);
  }

  double _getPreviousWidgetPixels(ScrollMetrics position) {
    double previousWidgetPixels = 0;
    int widgetIndex = 0;
    double widgetPixels = _getHeight(childrenKeys[widgetIndex]);
    while (widgetPixels < position.pixels) {
      widgetIndex++;

      previousWidgetPixels = widgetPixels;
      widgetPixels += _getHeight(childrenKeys[widgetIndex]);
    }
    return previousWidgetPixels;
  }

  double _getNextWidgetPixels(ScrollMetrics position) {
    int widgetIndex = 0;
    double widgetPixels = 0;
    while (widgetPixels < position.pixels) {
      widgetPixels += _getHeight(childrenKeys[widgetIndex]);

      widgetIndex++;
    }
    return widgetPixels;
  }

  double _getWidgetPixels(ScrollMetrics position) {
    int widgetIndex = 0;
    double widgetPixels = 0;
    double nextWidgetPixels = _getHeight(childrenKeys[widgetIndex]);
    while (nextWidgetPixels < position.pixels) {
      widgetIndex++;

      widgetPixels = nextWidgetPixels;
      nextWidgetPixels += _getHeight(childrenKeys[widgetIndex]);
    }

    if (position.pixels - widgetPixels < nextWidgetPixels - position.pixels) {
      return widgetPixels;
    } else {
      return nextWidgetPixels;
    }
  }

  double _getHeight(GlobalKey key) {
    final box = key.currentContext.findRenderObject() as RenderBox;
//    final pos = box.localToGlobal(Offset.zero);
    return box.size.height;
  }

  double _getTop(GlobalKey key) {
    final box = key.currentContext.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    return pos.dy;
  }


  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    print("_getTargetPixels");
    if (velocity < -tolerance.velocity)
      return _getPreviousWidgetPixels(position);
    else if (velocity > tolerance.velocity)
      return _getNextWidgetPixels(position);
    return _getWidgetPixels(position);
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    print("createBallisticSimulation");
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity >= 0.0 && position.pixels > _getTop(childrenKeys[childrenKeys.length-1]))
    )
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(
          spring, position.pixels, target, velocity, tolerance: tolerance);
    return null;
  }

  @override
  ScrollPhysics buildParent(ScrollPhysics ancestor) {
    // TODO: implement buildParent
    return super.buildParent(ancestor);
  }

  @override
  bool get allowImplicitScrolling => false;
}

class SnapScrollPhysics2 extends ScrollPhysics {
  List<GlobalKey> _childrenKeys;

  SnapScrollPhysics2({
    ScrollPhysics parent
  }) : super(parent: parent);

  get childrenKeys => _childrenKeys;
  set childrenKeys(List<GlobalKey> keys) {
    _childrenKeys = keys;
    print('Keys set to: ' + _childrenKeys.toString());
  }

  @override
  SnapScrollPhysics2 applyTo(ScrollPhysics ancestor) {
    return SnapScrollPhysics2(parent: buildParent(ancestor));
  }

  double _getPreviousWidgetPixels(ScrollMetrics position) {
    double previousWidgetPixels = 0;
    int widgetIndex = 0;
    double widgetPixels = _getHeight(childrenKeys[widgetIndex]);
    while (widgetPixels < position.pixels) {
      widgetIndex++;

      previousWidgetPixels = widgetPixels;
      widgetPixels += _getHeight(childrenKeys[widgetIndex]);
    }
    return previousWidgetPixels;
  }

  double _getNextWidgetPixels(ScrollMetrics position) {
    int widgetIndex = 0;
    double widgetPixels = 0;
    while (widgetPixels < position.pixels) {
      widgetPixels += _getHeight(childrenKeys[widgetIndex]);

      widgetIndex++;
    }
    return widgetPixels;
  }

  double _getWidgetPixels(ScrollMetrics position) {
    int widgetIndex = 0;
    double widgetPixels = 0;
    double nextWidgetPixels = _getHeight(childrenKeys[widgetIndex]);
    while (nextWidgetPixels < position.pixels) {
      widgetIndex++;

      widgetPixels = nextWidgetPixels;
      nextWidgetPixels += _getHeight(childrenKeys[widgetIndex]);
    }

    if (position.pixels - widgetPixels < nextWidgetPixels - position.pixels) {
      return widgetPixels;
    } else {
      return nextWidgetPixels;
    }
  }

  double _getHeight(GlobalKey key) {
    final box = key.currentContext.findRenderObject() as RenderBox;
//    final pos = box.localToGlobal(Offset.zero);
    return box.size.height;
  }

  double _getTop(GlobalKey key) {
    final box = key.currentContext.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    return pos.dy;
  }


  double _getTargetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    print("_getTargetPixels");
    if (velocity < -tolerance.velocity)
      return _getPreviousWidgetPixels(position);
    else if (velocity > tolerance.velocity)
      return _getNextWidgetPixels(position);
    return _getWidgetPixels(position);
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    print("createBallisticSimulation");
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity >= 0.0 && position.pixels > _getTop(childrenKeys[childrenKeys.length-1]))
    )
      return super.createBallisticSimulation(position, velocity);
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)
      return ScrollSpringSimulation(
          spring, position.pixels, target, velocity, tolerance: tolerance);
    return null;
  }

  @override
  ScrollPhysics buildParent(ScrollPhysics ancestor) {
    // TODO: implement buildParent
    return super.buildParent(ancestor);
  }

  @override
  bool get allowImplicitScrolling => false;
}