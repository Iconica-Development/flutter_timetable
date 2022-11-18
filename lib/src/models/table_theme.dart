// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class TableTheme {
  /// The [TableTheme] to style the [Table] with. Configure the line, text
  /// and offsets here.
  const TableTheme({
    this.lineColor = const Color(0x809E9E9E),
    this.lineStrokeWidth = 2,
    this.tableTextOffset = 5,
    this.lineDashDistance = 10,
    this.lineDashLength = 10,
    this.timeStyle,
    this.tablePaddingStart = 10,
    this.tablePaddingEnd = 15,
    this.blockPaddingBetween = 0,
  });

  /// The color of the lines.
  final Color lineColor;

  /// The height of the lines.
  final double lineStrokeWidth;

  /// The distance between dashes on the line.
  final double lineDashDistance;

  /// The length of the dashes on the line.
  final double lineDashLength;

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
