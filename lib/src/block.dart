part of timetable;

class Block extends StatelessWidget {
  const Block({
    required this.start,
    required this.end,
    required this.startHour,
    required this.blockWidth,
    this.linePadding = 8,
    this.child,
    Key? key,
  }) : super(key: key);

  /// The start time of the block in 24 hour format
  final TimeOfDay start;

  /// The end time of the block in 24 hour format
  final TimeOfDay end;

  /// Widget that will be displayed within the block.
  final Widget? child;

  /// The start hour of the timetable.
  final int startHour;

  /// The width of the block if there is no child
  final double blockWidth;

  /// The padding between the lines and the numbers
  final double linePadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        top:
            (((start.hour - startHour) * 60) + start.minute) * sizePerMinute() +
                linePadding,
      ),
      height: (((end.hour - start.hour) * 60) + end.minute - start.minute) *
          sizePerMinute(),
      child: child ??
          Container(
            height:
                (((end.hour - start.hour) * 60) + end.minute - start.minute) *
                    sizePerMinute(),
            width: blockWidth,
            color: Colors.red.withOpacity(0.5),
          ),
    );
  }

  double sizePerMinute() {
    // TODO(anyone): calculate this based on the size of the screen
    return 80 / 60;
  }
}
