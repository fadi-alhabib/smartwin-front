import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';

class C4WinAnimation extends HookWidget {
  const C4WinAnimation({
    super.key,
    required this.animationController,
  });
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(alignment: Alignment.center, children: [
      Animate(
        controller: animationController,
        autoPlay: false,
        effects: const [ScaleEffect()],
        child: Lottie.asset(
          "images/animations/sparkles-1.json",
        ),
      ),
      Animate(
        controller: animationController,
        autoPlay: false,
        effects: const [ScaleEffect()],
        child: Lottie.asset(
          "images/animations/sparkles-2.json",
        ),
      ),
      Image.asset(
        "images/images/winner.png",
        width: MediaQuery.of(context).size.width * 0.4,
      )
          .animate(controller: animationController, autoPlay: false)
          .scale(duration: 1.seconds)
          .rotate(duration: 1.seconds)
    ]));
  }
}
