part of timetable;

class Table extends StatelessWidget {
  const Table({
    required this.startHour,
    required this.endHour,
    this.columnHeight = 80,
    this.theme = const TableTheme(),
    Key? key,
  }) : super(key: key);

  final int startHour;
  final int endHour;
  final double columnHeight;
  final TableTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = startHour; i <= endHour; i++) ...[
          SizedBox(
            height: i == endHour ? columnHeight / 2 : columnHeight,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${i.toString().padLeft(2, '0')}:00',
                      style: theme.timeStyle,
                    ),
                    const SizedBox(
                      width: 5,
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
                    margin: const EdgeInsets.only(
                      left: 40,
                    ),
                    height: theme.lineHeight,
                    child: Row(
                      children: [
                        for (int i = 0; i < 25; i++) ...[
                          Container(
                            width:
                                (MediaQuery.of(context).size.width - 40) / 25,
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
