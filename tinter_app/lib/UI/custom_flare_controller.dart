import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';


class CustomFlareController extends FlareController {
  ActorAnimation forwardAnimation, reverseAnimation;
  final AnimationController controller;
  final String forwardAnimationName;
  final String reverseAnimationName;

  CustomFlareController(
      {@required this.controller,
      this.reverseAnimationName,
      @required this.forwardAnimationName})
      : assert(controller.lowerBound == 0 && controller.upperBound == 1);

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (controller.velocity > 0) {
      forwardAnimation.apply(forwardAnimation.duration * controller.value, artboard, 1);
    } else if (controller.velocity < 0) {
      reverseAnimation.apply(reverseAnimation.duration * (1-controller.value), artboard, 1);
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    forwardAnimation = artboard.getAnimation(forwardAnimationName);
    reverseAnimation = artboard.getAnimation(reverseAnimationName);
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}
