// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Tile {
  int col; //x
  int row; //y
  Color color;

  Tile({
    required this.col,
    required this.row,
    required int color,
  }) : color = getTileColor(color);

  static Color getTileColor(int color) {
    switch (color) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  @override
  String toString() => "[$col, $row]";

  @override
  int get hashCode => col.hashCode ^ row.hashCode ^ color.hashCode;

  @override
  bool operator ==(covariant Tile other) {
    if (identical(this, other)) return true;

    return other.col == col && other.row == row && other.color == color;
  }
}

enum TileOwner {
  blank,
  player,
  enemy,
}
