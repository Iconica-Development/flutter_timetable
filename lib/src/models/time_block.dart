part of timetable;

class TimeBlock {
  TimeBlock({
    required this.start,
    required this.end,
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
}
