import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class C4LoseAnimation extends StatelessWidget {
  const C4LoseAnimation({super.key, required this.animationController});
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Lottie.asset(
          "images/animations/game_over.json",
          width: MediaQuery.of(context).size.width * 0.7,
          repeat: false,
        ),
      )
          .animate(controller: animationController, autoPlay: false)
          .scale(duration: 1.seconds)
          .rotate(duration: 1.seconds),
    );
  }
}
