import 'package:flutter/material.dart';

class TableTheme {
  /// The [TableTheme] to style the [Table] with. Configure the line, text
  /// and offsets here.
  const TableTheme({
    this.lineColor = const Color(0x809E9E9E),
    this.lineHeight = 2,
    this.tableTextOffset = 5,
    this.lineDashFrequency = 25,
    this.timeStyle,
    this.tablePaddingStart = 10,
    this.tablePaddingEnd = 15,
    this.blockPaddingBetween = 0,
  });

  /// The color of the lines.
  final Color lineColor;

  /// The height of the lines.
  final double lineHeight;

  /// The amount of dashes on the line.
  final int lineDashFrequency;

  /// Distance between the time text and the line.
  final double tableTextOffset;

  /// The style of the time text.
  final TextStyle? timeStyle;

  /// The padding between the table markings and the first block.
  final double tablePaddingStart;

  /// The padding between the last block and the end of the table.
  final double tablePaddingEnd;

  /// The padding between two blocks.
  final double blockPaddingBetween;
}
