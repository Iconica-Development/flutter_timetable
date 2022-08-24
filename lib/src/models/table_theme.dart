part of timetable;

class TableTheme {
  const TableTheme({
    this.lineColor = const Color(0x809E9E9E),
    this.lineHeight = 2,
    this.timeStyle = const TextStyle(),
  });

  /// The color of the lines.
  final Color lineColor;

  /// The height of the lines.
  final double lineHeight;

  /// The style of the time text.
  final TextStyle timeStyle;
}
