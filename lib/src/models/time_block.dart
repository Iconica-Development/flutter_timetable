// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class TimeBlock {
  /// The model used for a [Block] in a [TimeTable] which can contain a Widget.
  TimeBlock({
    required this.start,
    required this.end,
    this.id = 0,
    this.child,
  }) : assert(
          start.hour <= end.hour ||
              (start.hour == end.hour && start.minute < end.minute),
          'start time must be less than end time',
        );

  /// The start time of the block in 24 hour format
  /// The start time should be before the end time
  final TimeOfDay start;

  /// The end time of the block in 24 hour format
  /// The end time should be after the start time
  final TimeOfDay end;

  /// The child widget that will be displayed within the block.
  /// The size of the parent widget should dictate the size of the child.
  final Widget? child;

  /// The identifier of the block that is used to collapse blocks in 1 column.
  /// Leave empty or 0 if you do not want to collapse blocks.
  final int id;

  /// Check if two blocks overlap each other
  bool collidesWith(TimeBlock block) {
    var startMinute = start.hour * 60 + start.minute;
    var endMinute = end.hour * 60 + end.minute;
    var otherStartMinute = block.start.hour * 60 + block.start.minute;
    var otherEndMinute = block.end.hour * 60 + block.end.minute;
    return startMinute < otherEndMinute && endMinute > otherStartMinute;
  }
}
