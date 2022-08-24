part of timetable;

class Table extends StatelessWidget {
  const Table({
    required this.startHour,
    required this.endHour,
    Key? key,
  }) : super(key: key);

  final int startHour;
  final int endHour;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = startHour; i <= endHour; i++) ...[
          SizedBox(
            height: i == endHour ? 40 : 80,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${i.toString().padLeft(2, '0')}:00',
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.grey.withOpacity(0.5),
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
                    height: 2,
                    child: Row(
                      children: [
                        for (int i = 0; i < 25; i++) ...[
                          Container(
                            width:
                                (MediaQuery.of(context).size.width - 40) / 25,
                            height: 2,
                            color: i.isEven
                                ? Colors.grey.withOpacity(0.5)
                                : Colors.transparent,
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
