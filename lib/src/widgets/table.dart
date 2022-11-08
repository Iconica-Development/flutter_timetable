// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:timetable/src/models/table_theme.dart';

class Table extends StatelessWidget {
  /// The [Table] to draw an overview of timerange with corresponding hour lines
  const Table({
    required this.startHour,
    required this.endHour,
    this.tableDirection = Axis.vertical,
    this.hourDimension = 80,
    this.tableOffset = 20,
    this.tableHeight = 400,
    this.theme = const TableTheme(),
    Key? key,
  }) : super(key: key);

  //// The height of the table when the tableDirection is horizontal to render the vertical lines
  final double tableHeight;

  /// The [Axis] in which the table is layed out.
  final Axis tableDirection;

  /// The hour the table starts at.
  final int startHour;

  /// The hour the table ends at.
  final int endHour;

  /// The length in pixel of a single hour in the table.
  final double hourDimension;

  /// The offset of the table;
  final double tableOffset;

  /// The theme used by the table.
  final TableTheme theme;

  @override
  Widget build(BuildContext context) {
    // calculate the textheight of the hour indicator
    var textSize = calculateTextHeight(context);
    if (tableDirection == Axis.horizontal) {
      return Row(
        children: [
          for (var i = startHour; i <= endHour; i++) ...[
            SizedBox(
              width: (i == endHour) ? hourDimension / 2 : hourDimension,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        '${((i == 24) ? '00' : i.toString()).padLeft(2, '0')}'
                        ':00',
                        style: theme.timeStyle ??
                            Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: theme.tableTextOffset),
                      Container(
                        color: theme.lineColor,
                        width: theme.lineHeight,
                        height: tableHeight,
                      ),
                    ],
                  ),
                  // if not the last block
                  if (i != endHour) ...[
                    SizedBox(
                      width: hourDimension / 2 -
                          textSize.dx / 2 -
                          theme.lineHeight,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: textSize.dy + theme.tableTextOffset,
                        ),
                        // draw dotted line
                        for (int i = 0;
                            i <
                                tableHeight /
                                    ((theme.lineDashLength +
                                            theme.lineDashDistance) /
                                        2);
                            i++) ...[
                          Container(
                            width: theme.lineHeight,
                            height: i.isEven
                                ? theme.lineDashLength
                                : theme.lineDashDistance,
                            color:
                                i.isEven ? theme.lineColor : Colors.transparent,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    }
    return Column(
      children: [
        for (int i = startHour; i <= endHour; i++) ...[
          SizedBox(
            height: i == endHour ? hourDimension / 2 : hourDimension,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${i.toString().padLeft(2, '0')}:00',
                      style: theme.timeStyle ??
                          Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      width: theme.tableTextOffset,
                    ),
                    Expanded(
                      child: Container(
                        height: theme.lineHeight,
                        color: theme.lineColor,
                      ),
                    )
                  ],
                ),
                if (i != endHour) ...[
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(
                      left: tableOffset,
                    ),
                    height: theme.lineHeight,
                    child: Row(
                      children: [
                        for (int i = 0;
                            i <
                                (MediaQuery.of(context).size.width -
                                        tableOffset -
                                        textSize.dx / 2) /
                                    ((theme.lineDashLength +
                                            theme.lineDashDistance) /
                                        2);
                            i++) ...[
                          Container(
                            width: i.isEven
                                ? theme.lineDashLength
                                : theme.lineDashDistance,
                            height: theme.lineHeight,
                            color:
                                i.isEven ? theme.lineColor : Colors.transparent,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Offset calculateTextHeight(BuildContext context, {String text = '00:00'}) {
    var textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: theme.timeStyle ?? Theme.of(context).textTheme.bodyText1,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return Offset(textPainter.width, textPainter.height);
  }
}
