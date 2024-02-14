// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_timetable/src/block_service.dart';
import 'package:flutter_timetable/src/models/table_theme.dart';
import 'package:flutter_timetable/src/models/time_block.dart';
import 'package:flutter_timetable/src/widgets/block.dart';
import 'package:flutter_timetable/src/widgets/table.dart' as table;

class Timetable extends StatefulWidget {
  /// [Timetable] widget that displays a timetable with [TimeBlock]s.
  /// The timetable automatically scrolls to the first item.
  /// A [TableTheme] can be provided to customize the look of the timetable.
  /// [mergeBlocks] and [combineBlocks] can be used to combine blocks
  /// and merge columns of blocks when possible.
  const Timetable({
    this.tableDirection = Axis.vertical,
    this.timeBlocks = const [],
    this.size,
    this.initialScrollTime,
    this.scrollController,
    this.scrollPhysics,
    this.hoursOffset = 0,
    this.startHour = 0,
    this.endHour = 24,
    this.blockDimension = 50,
    this.blockColor = Colors.blue,
    this.hourDimension = 80,
    this.theme = const TableTheme(),
    this.mergeBlocks = false,
    this.combineBlocks = true,
    this.sortByIdAscending = false,
    this.onOverScroll,
    this.onUnderScroll,
    this.scrollTriggerOffset = 120,
    this.scrollJumpToOffset = 115,
    super.key,
  })  : assert(
          scrollTriggerOffset > scrollJumpToOffset,
          'ScrollTriggerOffset cannot be smaller'
          ' then the scrollJumpToOffset.',
        ),
        assert(
            !(mergeBlocks && sortByIdAscending),
            'mergeBlocks and sortByIdAscending'
            ' cannot be enabled at the same time.');

  /// The Axis in which the table is layed out.
  final Axis tableDirection;

  /// The [Size] of the timetable.
  final Size? size;

  /// Hour at which the timetable starts.
  final int startHour;

  /// Hour at which the timetable ends.
  final int endHour;

  /// The time offset to increase all hour labels with
  /// this is used to make the timetable start at a different time and go past midnight.
  final int hoursOffset;

  /// The time blocks that will be displayed in the timetable.
  final List<TimeBlock> timeBlocks;

  /// The dimension in pixels of the block if there is no child
  /// for the direction that the table expands in
  final double blockDimension;

  /// The color of the block if there is no child
  final Color blockColor;

  /// The dimension in pixels of one hour in the timetable.
  final double hourDimension;

  /// The theme of the timetable.
  final TableTheme theme;

  /// The initial time to scroll to if there are no timeblocks. If nothing is provided it will scroll to the current time or to the first block if there is one.
  final TimeOfDay? initialScrollTime;

  /// The scroll controller to control the scrolling of the timetable.
  final ScrollController? scrollController;

  /// The scroll physics used for the SinglechildScrollView.
  final ScrollPhysics? scrollPhysics;

  /// Whether or not to merge blocks in 1 column that fit below eachother.
  final bool mergeBlocks;

  /// Whether or not to collapse blocks in 1 column if they have the same id.
  /// If blocks have the same id and time they will be combined into one block.
  final bool combineBlocks;

  /// Whether or not to sort blocks by their ID in ascending order.
  final bool sortByIdAscending;

  /// The offset which trigger the jump to either the previous or next page. Can't be lower then [scrollJumpToOffset].
  final double scrollTriggerOffset;

  /// When the jump is triggered this offset will be jumped outside of the min or max offset. Can't be higher then [scrollTriggerOffset].
  final double scrollJumpToOffset;

  final void Function()? onUnderScroll;
  final void Function()? onOverScroll;

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController =
        widget.scrollController ?? ScrollController(initialScrollOffset: 0);
    if (widget.timeBlocks.isNotEmpty) {
      _scrollToFirstBlock();
    } else {
      _scrollToInitialTime();
    }

    if (widget.onUnderScroll != null && widget.onOverScroll != null) {
      _scrollController.addListener(() {
        if (_scrollController.offset -
                _scrollController.position.maxScrollExtent >
            widget.scrollTriggerOffset) {
          if (widget.onOverScroll != null) {
            _scrollController.jumpTo(
                _scrollController.position.minScrollExtent -
                    widget.scrollJumpToOffset);

            widget.onOverScroll?.call();
          }
        } else if (_scrollController.position.minScrollExtent -
                _scrollController.offset >
            widget.scrollTriggerOffset) {
          if (widget.onUnderScroll != null) {
            _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent +
                    widget.scrollJumpToOffset);

            widget.onUnderScroll?.call();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TimeBlock> blocks;
    if (widget.combineBlocks) {
      blocks = combineBlocksWithId(widget.timeBlocks);
    } else {
      blocks = widget.timeBlocks;
    }

    if (widget.sortByIdAscending) {
      // if the id is zero then put it at the end
      blocks.sort((a, b) => (a.id != 0 ? a.id : double.infinity).compareTo(
            (b.id != 0 ? b.id : double.infinity),
          ));
    }

    var linePadding = _calculateTableTextSize().width;
    return SizedBox(
      width: widget.size?.width,
      height: widget.size?.height,
      child: SingleChildScrollView(
        physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
        controller: _scrollController,
        scrollDirection: widget.tableDirection,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            table.Table(
              hoursOffset: widget.hoursOffset,
              tableDirection: widget.tableDirection,
              startHour: widget.startHour,
              endHour: widget.endHour,
              hourDimension: widget.hourDimension,
              tableOffset: _calculateTableStart(widget.tableDirection).width,
              theme: widget.theme,
              size: widget.size,
            ),
            Container(
              margin: EdgeInsets.only(
                top: _calculateTableStart(widget.tableDirection).height,
                left: _calculateTableStart(widget.tableDirection).width,
              ),
              child: SingleChildScrollView(
                physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
                scrollDirection: widget.tableDirection == Axis.horizontal
                    ? Axis.vertical
                    : Axis.horizontal,
                child: (widget.tableDirection == Axis.horizontal)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: widget.theme.tableTextOffset),
                          if (widget.mergeBlocks || widget.combineBlocks) ...[
                            for (var orderedBlocks in (widget.mergeBlocks)
                                ? mergeBlocksInColumns(blocks)
                                : groupBlocksById(blocks)) ...[
                              Stack(
                                children: [
                                  for (var block in orderedBlocks) ...[
                                    _showBlock(block),
                                  ],
                                ],
                              ),
                              SizedBox(
                                height: widget.theme.blockPaddingBetween,
                              ),
                            ],
                          ] else ...[
                            for (var block in blocks) ...[
                              _showBlock(block, linePadding: linePadding),
                              SizedBox(
                                height: widget.theme.blockPaddingBetween,
                              ),
                            ],
                          ],
                          // emtpy block at the end
                          SizedBox(
                            height: max(
                              widget.theme.tablePaddingEnd -
                                  widget.theme.blockPaddingBetween,
                              0,
                            ),
                          ),
                        ],
                      )
                    : IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.mergeBlocks || widget.combineBlocks) ...[
                              for (var orderedBlocks in (widget.mergeBlocks)
                                  ? mergeBlocksInColumns(blocks)
                                  : groupBlocksById(blocks)) ...[
                                Stack(
                                  children: [
                                    for (var block in orderedBlocks) ...[
                                      _showBlock(block),
                                    ],
                                  ],
                                ),
                                SizedBox(
                                  width: widget.theme.blockPaddingBetween,
                                ),
                              ],
                            ] else ...[
                              for (var block in blocks) ...[
                                _showBlock(block),
                              ],
                            ],
                            SizedBox(
                              width: max(
                                widget.theme.tablePaddingEnd -
                                    widget.theme.blockPaddingBetween,
                                0,
                              ),
                              height: widget.hourDimension *
                                  (widget.endHour -
                                      widget.startHour +
                                      0.5), // empty halfhour at the end
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Size _calculateTableStart(Axis axis) => Size(
        (axis == Axis.horizontal)
            ? _calculateTableTextSize().width / 2
            : _calculateTableTextSize().width +
                widget.theme.tablePaddingStart +
                widget.theme.tableTextOffset,
        (axis == Axis.vertical)
            ? _calculateTableTextSize().height / 2
            : _calculateTableTextSize().height,
      );

  Widget _showBlock(TimeBlock block, {double linePadding = 0}) => Block(
        blockDirection: widget.tableDirection,
        linePadding: linePadding,
        start: block.start,
        end: block.end,
        startHour: widget.startHour,
        hourDimension: widget.hourDimension,
        blockDimension: widget.blockDimension,
        blockColor: widget.blockColor,
        child: block.child,
      );

  void _scrollToFirstBlock() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var earliestStart = widget.timeBlocks.map((block) => block.start).reduce(
            (a, b) =>
                a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute)
                    ? a
                    : b,
          );
      var initialOffset =
          (widget.hourDimension * (widget.endHour - widget.startHour)) *
                  ((earliestStart.hour - widget.startHour) /
                      (widget.endHour - widget.startHour)) +
              _calculateTableTextSize().width / 2;
      _scrollController.jumpTo(
        initialOffset,
      );
      // TODO(freek): stop the controller from resetting
    });
  }

  void _scrollToInitialTime() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var startingTime = widget.initialScrollTime ?? TimeOfDay.now();
      var initialOffset =
          (widget.hourDimension * (widget.endHour - widget.startHour)) *
                  ((startingTime.hour - widget.startHour) /
                      (widget.endHour - widget.startHour)) +
              _calculateTableTextSize().width / 2;
      _scrollController.jumpTo(
        initialOffset,
      );
    });
  }

  Size _calculateTableTextSize() => (TextPainter(
        text: TextSpan(
          text: '22:22',
          style:
              widget.theme.timeStyle ?? Theme.of(context).textTheme.bodyLarge,
        ),
        maxLines: 1,
        textScaler: MediaQuery.of(context).textScaler,
        textDirection: TextDirection.ltr,
      )..layout())
          .size;

  double calculateTableHeight() {
    var sum = 0.0;
    if (widget.mergeBlocks || widget.combineBlocks) {
      for (var orderedBlocks in (widget.mergeBlocks)
          ? mergeBlocksInColumns(widget.timeBlocks)
          : groupBlocksById(widget.timeBlocks)) {
        // check if any orderedBlock collides with another orderedBlock
        if (orderedBlocks.map((block) => block.id).toSet().isNotEmpty &&
            orderedBlocks.any(
              (block) => orderedBlocks.any(
                (block2) => block != block2 && block.collidesWith(block2),
              ),
            )) {
          // the sum is the combination of all the blocks
          sum += orderedBlocks
              .map((block) => block.childDimension ?? widget.blockDimension)
              .reduce((a, b) => a + b);
        } else {
          sum +=
              // get the highest block within the group
              orderedBlocks
                      .map(
                        (block) => max(
                          block.childDimension ?? 0,
                          widget.blockDimension,
                        ),
                      )
                      .reduce(max) +
                  widget.theme.blockPaddingBetween;
        }
      }
    } else {
      // sum of all the widget heights
      sum = widget.timeBlocks
          .map((block) => block.childDimension ?? widget.blockDimension)
          .reduce((a, b) => a + b);
      sum += widget.timeBlocks.length * widget.theme.blockPaddingBetween;
    }
    return sum;
  }
}
