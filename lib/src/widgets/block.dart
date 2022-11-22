// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class Block extends StatelessWidget {
  /// The [Block] to create a Widget or container in a [TimeTable].
  const Block({
    required this.start,
    required this.end,
    required this.startHour,
    required this.blockDimension,
    required this.hourDimension,
    required this.blockDirection,
    this.blockColor = Colors.blue,
    this.linePadding = 8,
    this.child,
    Key? key,
  }) : super(key: key);

  /// The [Axis] along which the [Block] will be displayed.
  final Axis blockDirection;

  /// The start time of the block in 24 hour format
  final TimeOfDay start;

  /// The end time of the block in 24 hour format
  final TimeOfDay end;

  /// Widget that will be displayed within the block
  final Widget? child;

  /// The start hour of the timetable.
  final int startHour;

  /// The dimension in pixels of one hour in the timetable
  final double hourDimension;

  /// The dimension in pixels of the block if there is no child
  final double blockDimension;

  /// The color of the block if there is no child
  final Color blockColor;

  /// The padding between the lines and the numbers
  final double linePadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blockColor,
      margin: EdgeInsets.only(
        top: (blockDirection == Axis.vertical)
            ? (((start.hour - startHour) * Duration.minutesPerHour) +
                        start.minute) *
                    _sizePerMinute() +
                linePadding
            : 0,
        left: (blockDirection == Axis.horizontal)
            ? ((((start.hour - startHour) * Duration.minutesPerHour) +
                        start.minute) *
                    _sizePerMinute() +
                linePadding)
            : 0,
      ),
      height: (blockDirection == Axis.vertical)
          ? (((end.hour - start.hour) * Duration.minutesPerHour) +
                  end.minute -
                  start.minute) *
              _sizePerMinute()
          : null,
      width: (blockDirection == Axis.horizontal)
          ? (((end.hour - start.hour) * Duration.minutesPerHour) +
                  end.minute -
                  start.minute) *
              _sizePerMinute()
          : null,
      child: child ??
          SizedBox(
            height: (blockDirection == Axis.horizontal) ? blockDimension : 0,
            width: (blockDirection == Axis.vertical) ? blockDimension : 0,
          ),
    );
  }

  double _sizePerMinute() {
    return hourDimension / Duration.minutesPerHour;
  }
}
