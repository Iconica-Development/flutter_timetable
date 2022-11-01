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
    this.timeBlocks = const [],
    this.scrollController,
    this.scrollPhysics,
    this.startHour = 0,
    this.endHour = 24,
    this.blockWidth = 50,
    this.blockColor = const Color(0x80FF0000),
    this.hourHeight = 80,
    this.theme = const TableTheme(),
    this.mergeBlocks = false,
    this.combineBlocks = true,
    Key? key,
  }) : super(key: key);

  /// Hour at which the timetable starts.
  final int startHour;

  /// Hour at which the timetable ends.
  final int endHour;

  /// The time blocks that will be displayed in the timetable.
  final List<TimeBlock> timeBlocks;

  /// The width of the block if there is no child
  final double blockWidth;

  /// The color of the block if there is no child
  final Color blockColor;

  /// The heigh of one hour in the timetable.
  final double hourHeight;

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
    _scrollController = widget.scrollController ?? ScrollController();
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
    return SingleChildScrollView(
      physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
      controller: _scrollController,
      child: Stack(
        children: [
          table.Table(
            startHour: widget.startHour,
            endHour: widget.endHour,
            hourHeight: widget.hourHeight,
            tableOffset: _calculateTableStart(),
            theme: widget.theme,
          ),
          Container(
            margin: EdgeInsets.only(
              left: _calculateTableStart(),
            ),
            child: SingleChildScrollView(
              physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
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
                      height: widget.hourHeight *
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

  double _calculateTableStart() {
    return _calculateTableTextSize().width +
        widget.theme.tablePaddingStart +
        widget.theme.tableTextOffset;
  }

  Widget _showBlock(TimeBlock block) {
    return Block(
      start: block.start,
      end: block.end,
      startHour: widget.startHour,
      hourHeight: widget.hourHeight,
      blockWidth: widget.blockWidth,
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
          (widget.hourHeight * (widget.endHour - widget.startHour)) *
              ((earliestStart.hour - widget.startHour) /
                  (widget.endHour - widget.startHour));
      _scrollController.jumpTo(
        initialOffset,
      );
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
}
