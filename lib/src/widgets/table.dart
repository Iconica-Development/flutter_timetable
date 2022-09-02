import 'package:flutter/material.dart';
import 'package:timetable/src/models/table_theme.dart';

class Table extends StatelessWidget {
  /// The [Table] to draw an overview of timerange with corresponding hour lines
  const Table({
    required this.startHour,
    required this.endHour,
    this.hourHeight = 80,
    this.tableOffset = 40,
    this.theme = const TableTheme(),
    Key? key,
  }) : super(key: key);

  /// The hour the table starts at.
  final int startHour;

  /// The hour the table ends at.
  final int endHour;

  /// The height of a single hour in the table.
  final double hourHeight;

  /// The offset of the table;
  final double tableOffset;

  /// The theme used by the table.
  final TableTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = startHour; i <= endHour; i++) ...[
          SizedBox(
            height: i == endHour ? hourHeight / 2 : hourHeight,
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
                        for (int i = 0; i < theme.lineDashFrequency; i++) ...[
                          Container(
                            width: (MediaQuery.of(context).size.width -
                                    tableOffset) /
                                theme.lineDashFrequency,
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
}
