library;

import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:sw/common/constants/colors.dart';
part 'wave.dart';
part "sound_controller.dart";

class AnimatedSoundWidget extends StatefulWidget {
  final SoundController soundController;
  final String title;
  final String? image;
  const AnimatedSoundWidget(
      {super.key,
      required this.soundController,
      required this.title,
      this.image});

  @override
  _AnimatedSoundWidgetState createState() => _AnimatedSoundWidgetState();
}

class _AnimatedSoundWidgetState extends State<AnimatedSoundWidget>
    with TickerProviderStateMixin {
  static const _kScaleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  late AnimationController rotationController;
  late AnimationController scaleController;
  double rotation = 0;
  double scale = 0.85;

  bool get showWaves => !scaleController.isDismissed;

  void updateRotation() => setState(() {
        rotation = (rotationController.value * 2) * pi;
      });

  void updateScale() => setState(() {
        scale = (scaleController.value * 0.2) + 0.85;
      });

  @override
  void initState() {
    super.initState();

    rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(updateRotation)
          ..repeat();

    scaleController =
        AnimationController(vsync: this, duration: _kScaleDuration)
          ..addListener(updateScale)
          ..forward();

    widget.soundController.addListener(_scaleListener);
  }

  void _scaleListener() {
    animateToScale(widget.soundController.value);
  }

  void animateToScale(double newScale) {
    scaleController.animateTo((newScale));
  }

  @override
  void dispose() {
    widget.soundController.removeListener(_scaleListener);
    rotationController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 48, minHeight: 48, maxHeight: 80, maxWidth: 80),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (showWaves) ...[
                  Wave(color: Colors.red, scale: scale, rotation: rotation),
                  Wave(
                      color: Colors.green,
                      scale: scale,
                      rotation: rotation * 2 - 30),
                  Wave(
                      color: Colors.blue,
                      scale: scale,
                      rotation: rotation * 3 - 45),
                ],
                Container(
                  clipBehavior: Clip.antiAlias,
                  constraints: const BoxConstraints.expand(),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryColor,
                        Color.fromARGB(255, 255, 193, 10),
                        Color.fromARGB(255, 230, 180, 26),
                        Color.fromARGB(255, 214, 160, 80),
                      ],
                    ),
                  ),
                  child: widget.image != null
                      ? Image.asset(
                          widget.image!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.mic),
                ),
              ],
            ),
          ),
        ),
        Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
