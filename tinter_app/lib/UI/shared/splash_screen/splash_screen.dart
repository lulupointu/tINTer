import 'package:flare_flutter/base/animation/actor_animation.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return Scaffold(
          backgroundColor: tinterTheme.colors.background,
          body: child,
        );
      },
      child: Center(
        child: SizedBox(
          height: 400,
          width: 400,
          child: FlareActor(
            'assets/splash_screen/tinter_logo_splash_screen.flr',
            controller: SplashScreenFlareController(),
          ),
        ),
      ),
    );
  }
}

class SplashScreenFlareController extends FlareController {
  bool isFirstAnimationDone = false;
  ActorAnimation _flame;
  ActorAnimation _flameAndHeart;
  double time = 0.0;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (time + elapsed > 2) {
      isFirstAnimationDone = true;
    }
    time = (time + elapsed) % 2;

    if (isFirstAnimationDone) {
      _flame.apply(time, artboard, 0.2);
    } else {
      _flameAndHeart.apply(time, artboard, 0.2);
    }

    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _flame = artboard.getAnimation('flame');
    _flameAndHeart = artboard.getAnimation('flame_and_heart');
  }

  @override
  void setViewTransform(_) {}
}
