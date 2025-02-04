import 'package:flutter/material.dart';
import 'package:sw/common/constants/colors.dart';

import 'helpers.dart';

class AnimatedButton extends StatefulWidget {
  AnimatedButton(
      {super.key,
      required this.scaleAnimation,
      required this.translateAnimation,
      required this.child,
      this.onTap,
      this.gradient,
      this.overlayColor,
      this.margin,
      this.padding});
  bool scaleAnimation;
  bool translateAnimation;
  void Function()? onTap;
  Gradient? gradient;
  Color? overlayColor;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Widget child;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _translateController;
  late AnimationController _scaleController;
  @override
  void initState() {
    widget.translateAnimation ? translateController() : null;
    widget.scaleAnimation ? scaleController() : null;

    super.initState();
  }

  @override
  void dispose() {
    widget.translateAnimation ? _translateController.dispose() : null;
    widget.scaleAnimation ? _scaleController.dispose() : null;
    super.dispose();
  }

  translateController() {
    _translateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..forward()
      ..repeat(reverse: true);
  }

  scaleController() {
    _scaleController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.05,
      duration: const Duration(milliseconds: 1500),
    )
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scaleAnimation && widget.translateAnimation == false) {
      return ScaleAnimation(
          scaleController: _scaleController, child: buildContainer());
    } else if (widget.translateAnimation && widget.scaleAnimation == false) {
      return TranslateAnimtion(
          translateController: _translateController, child: buildContainer());
    } else if (widget.scaleAnimation && widget.translateAnimation) {
      return TranslateAnimtion(
          translateController: _translateController,
          child: ScaleAnimation(
              scaleController: _scaleController, child: buildContainer()));
    } else {
      return buildContainer();
    }
  }

  Widget buildContainer() {
    return Container(
        margin: widget.margin,
        padding: widget.padding,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(20, 0, 0, 0),
                offset: Offset(-3.7, -3.7),
                blurRadius: 3,
                spreadRadius: 0.0,
              ),
              BoxShadow(
                color: Color.fromARGB(20, 0, 0, 0),
                offset: Offset(4.7, 4.7),
                blurRadius: 3,
                spreadRadius: 0.0,
              ),
            ],
            gradient: widget.gradient ??
                const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor,
                    Color.fromARGB(255, 255, 193, 10),
                    Color.fromARGB(255, 230, 180, 26),
                    Color.fromARGB(255, 214, 160, 80),
                  ],
                ),
            color: const Color.fromARGB(255, 240, 182, 7),
            borderRadius: BorderRadius.circular(20)),
        height: 50,
        width: getScreenSize(context).width / 2.7,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashFactory: InkSparkle.splashFactory,
            overlayColor: WidgetStateColor.resolveWith(
                (states) => widget.overlayColor ?? Colors.blue),
            onTap: widget.onTap,
            child: SizedBox.expand(child: widget.child),
          ),
        ));
  }
}

class TranslateAnimtion extends StatelessWidget {
  TranslateAnimtion(
      {super.key, required this.translateController, required this.child});
  AnimationController? translateController;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: translateController!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -5 * translateController!.value),
            child: child,
          );
        },
        child: child);
  }
}

class ScaleAnimation extends StatelessWidget {
  ScaleAnimation(
      {super.key, required this.scaleController, required this.child});
  AnimationController scaleController;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: scaleController,
        builder: (context, child) {
          return Transform.scale(scale: scaleController.value, child: child);
        },
        child: child);
  }
}
