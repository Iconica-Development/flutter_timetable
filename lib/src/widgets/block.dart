import 'package:flutter/material.dart';

class Block extends StatelessWidget {
  /// The [Block] to create a Widget or container in a [TimeTable].
  const Block({
    required this.start,
    required this.end,
    required this.startHour,
    required this.blockWidth,
    required this.hourHeight,
    this.blockColor = const Color(0x80FF0000),
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

  /// The heigh of one hour in the timetable.
  final double hourHeight;

  /// The width of the block if there is no child
  final double blockWidth;

  /// The color of the block if there is no child
  final Color blockColor;

  /// The padding between the lines and the numbers
  final double linePadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: (((start.hour - startHour) * Duration.minutesPerHour) +
                    start.minute) *
                _sizePerMinute() +
            linePadding,
      ),
      height: (((end.hour - start.hour) * Duration.minutesPerHour) +
              end.minute -
              start.minute) *
          _sizePerMinute(),
      child: child ??
          Container(
            height: (((end.hour - start.hour) * Duration.minutesPerHour) +
                    end.minute -
                    start.minute) *
                _sizePerMinute(),
            width: blockWidth,
            color: blockColor,
          ),
    );
  }

  double _sizePerMinute() {
    return hourHeight / Duration.minutesPerHour;
  }
}
