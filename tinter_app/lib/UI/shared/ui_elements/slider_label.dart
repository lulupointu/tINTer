import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum Side {Right, Left}

class SliderLabel extends StatelessWidget {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final Side side;
  final double squareRadius;
  final double triangleSize;
  final double triangleRadius;

  SliderLabel({
    this.padding = const EdgeInsets.all(0.0),
    @required this.child,
    this.strokeColor = Colors.white,
    this.strokeWidth = 1,
    this.paintingStyle = PaintingStyle.fill,
    this.side = Side.Left,
    this.squareRadius = 10.0,
    this.triangleSize = 14.0,
    this.triangleRadius = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SliderLabelPainter(
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        paintingStyle: paintingStyle,
        side: side,
        squareRadius: squareRadius,
        triangleSize: triangleSize,
        triangleRadius: triangleRadius,
      ),
      child: Padding(
        padding: padding,
        child: Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: child,
        ),
      ),
    );

  }
}

class SliderLabelPainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final Side side;
  final double squareRadius;
  final double triangleSize;
  final double triangleRadius;

  SliderLabelPainter({
    this.strokeColor,
    this.strokeWidth,
    this.paintingStyle,
    this.side,
    this.squareRadius,
    this.triangleSize,
    this.triangleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getLabelPath(size.width, size.height), paint);
  }

  Path getLabelPath(double x, double y) {

    return side==Side.Left ? (
        Path()
      ..moveTo(0, 0+squareRadius)
      ..quadraticBezierTo(0, 0, squareRadius, 0)
      ..lineTo(x-squareRadius, 0)
      ..quadraticBezierTo(x, 0, x, squareRadius)
      ..lineTo(x, y-squareRadius)
      ..quadraticBezierTo(x, y, x-squareRadius, y)
      ..lineTo(triangleSize + triangleRadius, y)
      ..quadraticBezierTo(triangleSize, y, triangleSize - triangleRadius, y + triangleRadius)
      ..lineTo(triangleSize/2+triangleRadius, y+triangleSize-2*triangleRadius)
      ..quadraticBezierTo(triangleSize/2, y+triangleSize, triangleSize/2-triangleRadius, y+triangleSize-2*triangleRadius)
      ..lineTo(0+triangleRadius/2, y+triangleRadius)
      ..quadraticBezierTo(0, y, 0, y-triangleRadius)
    ) : (
        Path()
          ..moveTo(0, 0+squareRadius)
          ..quadraticBezierTo(0, 0, squareRadius, 0)
          ..lineTo(x-squareRadius, 0)
          ..quadraticBezierTo(x, 0, x, squareRadius)
          ..lineTo(x, y-triangleRadius)
          ..quadraticBezierTo(x, y-triangleRadius, x-triangleRadius/2, y+triangleRadius/2)
          ..lineTo(x - triangleSize/2 + triangleRadius, y + triangleSize - 2*triangleRadius)
          ..quadraticBezierTo(x - triangleSize/2, y+triangleSize, x - triangleSize/2 - triangleRadius, y + triangleSize - 2*triangleRadius)
          ..lineTo(x - triangleSize + triangleRadius, y + triangleRadius)
          ..quadraticBezierTo(x - triangleSize, y, x - triangleSize - triangleRadius, y)
          ..lineTo(0 + squareRadius, y)
          ..quadraticBezierTo(0, y, 0, y - squareRadius)
    );
  }

  @override
  bool shouldRepaint(SliderLabelPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}


// Example :
main() => runApp(MaterialApp(
  home: Scaffold(
    backgroundColor: Colors.black45,
    body: MyApp(),
  ),
));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SliderLabel(
        padding: const EdgeInsets.all(5.0),
        child: Text('Fête'),
        side: Side.Right,
      ),
    );
  }
}