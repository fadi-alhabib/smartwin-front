// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:smartwin/features/c4/models/connect4/user_model.dart';

class C4Move {
  final int column;
  final int row;
  final int color;
  final User user;

  C4Move({
    required this.column,
    required this.row,
    required this.color,
    required this.user,
  });

  C4Move copyWith({
    int? column,
    int? row,
    int? color,
    User? user,
  }) {
    return C4Move(
      column: column ?? this.column,
      row: row ?? this.row,
      color: color ?? this.color,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'column': column,
      'row': row,
      'color': color,
      'player': user.toMap(),
    };
  }

  factory C4Move.fromMap(Map<String, dynamic> map) {
    return C4Move(
      column: map['column'] as int,
      row: map['row'] as int,
      color: map['color'] as int,
      user: User.fromMap(map['player'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory C4Move.fromJson(String source) =>
      C4Move.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'C4Move(column: $column, row: $row, color: $color, user: $user)';
  }

  @override
  bool operator ==(covariant C4Move other) {
    if (identical(this, other)) return true;

    return other.column == column &&
        other.row == row &&
        other.color == color &&
        other.user == user;
  }

  @override
  int get hashCode {
    return column.hashCode ^ row.hashCode ^ color.hashCode ^ user.hashCode;
  }
}
