// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:timetable/src/block_service.dart';
import 'package:timetable/src/models/table_theme.dart';
import 'package:timetable/src/models/time_block.dart';
import 'package:timetable/src/widgets/block.dart';
import 'package:timetable/src/widgets/table.dart' as table;

class Timetable extends StatefulWidget {
  /// [Timetable] widget that displays a timetable with [TimeBlock]s.
  /// The timetable automatically scrolls to the first item.
  /// A [TableTheme] can be provided to customize the look of the timetable.
  /// [mergeBlocks] and [combineBlocks] can be used to combine blocks
  /// and merge columns of blocks when possible.
  const Timetable({
    this.tableDirection = Axis.vertical,
    this.timeBlocks = const [],
    this.scrollController,
    this.scrollPhysics,
    this.startHour = 0,
    this.endHour = 24,
    this.blockDimension = 50,
    this.blockColor = const Color(0x80FF0000),
    this.hourDimension = 80,
    this.theme = const TableTheme(),
    this.mergeBlocks = false,
    this.combineBlocks = true,
    Key? key,
  }) : super(key: key);

  /// The Axis in which the table is layed out.
  final Axis tableDirection;

  /// Hour at which the timetable starts.
  final int startHour;

  /// Hour at which the timetable ends.
  final int endHour;

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

  /// The scroll controller to control the scrolling of the timetable.
  final ScrollController? scrollController;

  /// The scroll physics used for the SinglechildScrollView.
  final ScrollPhysics? scrollPhysics;

  /// Whether or not to merge blocks in 1 column that fit below eachother.
  final bool mergeBlocks;

  /// Whether or not to collapse blocks in 1 column if they have the same id.
  /// If blocks have the same id and time they will be combined into one block.
  final bool combineBlocks;

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
    var linePadding = _calculateTableTextSize().width;
    return SingleChildScrollView(
      key: // TODO(freek): test if this is necessary
          ValueKey<int>(widget.timeBlocks.length),
      physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
      controller: _scrollController,
      scrollDirection: widget.tableDirection,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          table.Table(
            tableHeight: widget.tableDirection == Axis.horizontal
                ? _calculateTableHeight()
                : 0,
            tableDirection: widget.tableDirection,
            startHour: widget.startHour,
            endHour: widget.endHour,
            hourDimension: widget.hourDimension,
            tableOffset: _calculateTableStart(widget.tableDirection).width,
            theme: widget.theme,
          ),
          Container(
            margin: EdgeInsets.only(
              top: _calculateTableStart(widget.tableDirection).height,
              left: _calculateTableStart(widget.tableDirection).width,
            ),
            child: SingleChildScrollView(
              key: // TODO(freek): test if this is necessary
                  ValueKey<int>(widget.timeBlocks.length),
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
    );
  }

  Size _calculateTableStart(Axis axis) {
    return Size(
      (axis == Axis.horizontal)
          ? 0
          : _calculateTableTextSize().width +
              widget.theme.tablePaddingStart +
              widget.theme.tableTextOffset,
      (axis == Axis.vertical) ? 0 : _calculateTableTextSize().height,
    );
  }

  Widget _showBlock(TimeBlock block, {double linePadding = 0}) {
    return Block(
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
  }

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

  Size _calculateTableTextSize() {
    return (TextPainter(
      text: TextSpan(
        text: '22:22',
        style: widget.theme.timeStyle ?? Theme.of(context).textTheme.bodyText1,
      ),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout())
        .size;
  }

  double _calculateTableHeight() {
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
