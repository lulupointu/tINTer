// Flutter code sample for TweenAnimationBuilder

// This example shows an [IconButton] that "zooms" in when the widget first
// builds (its size smoothly increases from 0 to 24) and whenever the button
// is pressed, it smoothly changes its size to the new target value of either
// 48 or 24.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatefulWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double value = 100;
  bool buildOverlay = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp._title,
      home: Scaffold(
        appBar: AppBar(title: const Text(MyApp._title)),
        body: Center(
          child: InkWell(onTap: onTap, child: MyStatelessWidget(value, buildOverlay)),
        ),
      ),
    );
  }

  onTap() {
    setState(() {
      buildOverlay = !buildOverlay;
    });
  }
}

class MyStatelessWidget extends StatelessWidget {
  final double value;
  final bool buildOverlay;

  MyStatelessWidget(this.value, this.buildOverlay);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 100, end: value),
          duration: Duration(milliseconds: 300),
          builder: (BuildContext context, value, Widget child) {
            return Container(
              height: value,
              color: Colors.yellow,
            );
          },
        ),
        OverLayingWidget(100, buildOverlay),
        Container(
          height: 100,
          color: Colors.yellow,
        ),
      ],
    );
  }
}

class OverLayingWidget extends StatefulWidget {
  final double height;
  final bool buildOverlay;

  OverLayingWidget(this.height, this.buildOverlay);

  @override
  _OverLayingWidgetState createState() => _OverLayingWidgetState();
}

class _OverLayingWidgetState extends State<OverLayingWidget> {
  OverlayEntry _overlayEntry;

  OverlayEntry createOverlayEntry(context) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 0),
        duration: Duration(milliseconds: 300),
        builder: (BuildContext context, value, Widget child) {
          return Positioned(
            left: offset.dx,
            top: offset.dy + value,
            width: 500,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: 100,
                color: Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buildOverlay) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (_overlayEntry != null) {
            _overlayEntry.remove();
          }
          _overlayEntry = createOverlayEntry(context);
          Overlay.of(context).insert(_overlayEntry);
        },
      );
    } else {
      _overlayEntry?.remove();
    }
    return Container(
      height: widget.height,
      color: (widget.buildOverlay) ? Colors.white : Colors.red,
    );
  }
}
