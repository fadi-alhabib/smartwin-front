class BoardSettings {
  final int cols;
  final int rows;

  const BoardSettings({required this.cols, required this.rows});

  int totalTiles() {
    return cols * rows;
  }

  int winCondition() {
    return 4;
  }
}
