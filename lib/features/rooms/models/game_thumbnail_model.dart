import 'package:flutter/material.dart';

class GameThumbnailModel {
  final String image;
  final String title;
  final VoidCallback onPressed;

  GameThumbnailModel({
    required this.image,
    required this.title,
    required this.onPressed,
  });
}

final images = [
  'images/rooms/c4-game-thumb.webp',
  'images/rooms/quiz-game-thumb.webp',
  'images/rooms/imgaes-quiz-thumb.webp',
];
