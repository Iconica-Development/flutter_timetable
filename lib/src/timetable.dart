part of timetable;

class Timetable extends StatefulWidget {
  const Timetable({
    this.timeBlocks = const [],
    this.scrollController,
    this.scrollPhysics,
    this.startHour = 0,
    this.endHour = 24,
    this.blockWidth = 50,
    this.blockColor = const Color(0x80FF0000),
    this.hourHeight = 80,
    this.tablePaddingStart = 10,
    this.tablePaddingEnd = 15,
    this.theme = const TableTheme(),
    this.mergeBlocks = false,
    this.collapseBlocks = false,
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

  /// The padding between the table markings and the first block.
  final double tablePaddingStart;

  /// The padding between the last block and the end of the table.
  final double tablePaddingEnd;

  /// The theme of the timetable.
  final TableTheme theme;

  /// The scroll controller to control the scrolling of the timetable.
  final ScrollController? scrollController;

  /// The scroll physics used for the SinglechildScrollView.
  final ScrollPhysics? scrollPhysics;

  /// Whether or not to merge blocks in 1 column that fit below eachother.
  final bool mergeBlocks;

  /// Whether or not to collapse blocks in 1 column if they have the same id.
  final bool collapseBlocks;

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollToFirstBlock();
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
    var blocks = _collapseBlocks(widget.timeBlocks);
    return SingleChildScrollView(
      physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
      controller: _scrollController,
      child: Stack(
        children: [
          Table(
            startHour: widget.startHour,
            endHour: widget.endHour,
            columnHeight: widget.hourHeight,
            theme: widget.theme,
          ),
          Container(
            margin: EdgeInsets.only(
              left: _calculateTableTextSize().width +
                  widget.tablePaddingStart +
                  5,
            ),
            child: SingleChildScrollView(
              physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.mergeBlocks && !widget.collapseBlocks) ...[
                      for (var block in blocks) ...[
                        Block(
                          start: block.start,
                          end: block.end,
                          startHour: widget.startHour,
                          hourHeight: widget.hourHeight,
                          blockWidth: widget.blockWidth,
                          blockColor: widget.blockColor,
                          child: block.child,
                        ),
                      ],
                    ] else if (widget.mergeBlocks) ...[
                      for (var mergedBlocks
                          in _mergeBlocksInColumns(blocks)) ...[
                        Stack(
                          children: [
                            for (var block in mergedBlocks) ...[
                              Block(
                                start: block.start,
                                end: block.end,
                                startHour: widget.startHour,
                                hourHeight: widget.hourHeight,
                                blockWidth: widget.blockWidth,
                                blockColor: widget.blockColor,
                                child: block.child,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ] else if (widget.collapseBlocks) ...[
                      for (var groupedBlocks in _groupBlocksById(blocks)) ...[
                        Stack(
                          children: [
                            for (var block in groupedBlocks) ...[
                              Block(
                                start: block.start,
                                end: block.end,
                                startHour: widget.startHour,
                                hourHeight: widget.hourHeight,
                                blockWidth: widget.blockWidth,
                                blockColor: widget.blockColor,
                                child: block.child,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                    SizedBox(
                      width: widget.tablePaddingEnd,
                      height: widget.hourHeight *
                          (widget.endHour - widget.startHour + 0.5),
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

  /// Copmbine blocks that have the same id and the same time.
  List<TimeBlock> _collapseBlocks(List<TimeBlock> blocks) {
    var newBlocks = <TimeBlock>[];
    var groupedBlocks = <List<TimeBlock>>[];
    // order blocks by id and collides with another block
    for (var block in blocks) {
      // check if the block is already in one of the grouped blocks
      var found = false;
      for (var groupedBlock in groupedBlocks) {
        if (groupedBlock.first.id == block.id &&
            groupedBlock.first.start == block.start &&
            groupedBlock.first.end == block.end) {
          groupedBlock.add(block);
          found = true;
          break;
        }
      }
      if (!found) {
        if (blocks
            .where(
              (b) =>
                  b != block &&
                  b.id == block.id &&
                  b.start == block.start &&
                  b.end == block.end,
            )
            .isNotEmpty) {
          groupedBlocks.add([block]);
        } else {
          newBlocks.add(block);
        }
      }
    }
    // 8.10 8.40 8.55
    //
    for (var block in groupedBlocks) {
      // combine the blocks into one block
      // calculate the endtime of the combined block
      var startMinute = block.first.start.minute + block.first.start.hour * 60;
      var endMinute = block.first.end.minute + block.first.end.hour * 60;
      var durationMinute = (endMinute - startMinute) * block.length;

      var endTime = TimeOfDay(
        hour: (startMinute + durationMinute) ~/ 60,
        minute: (startMinute + durationMinute) % 60,
      );
      var newBlock = TimeBlock(
        start: block.first.start,
        end: endTime,
        child: Column(
          children: [
            for (var b in block) ...[b.child ?? Container()],
          ],
        ),
      );
      newBlocks.add(newBlock);
    }
    return newBlocks;
  }

  List<List<TimeBlock>> _groupBlocksById(List<TimeBlock> blocks) {
    var groupedBlocks = <List<TimeBlock>>[];
    var defaultGroup = <TimeBlock>[];
    for (var block in blocks) {
      var found = false;
      if (block.id == 0) {
        defaultGroup.add(block);
      } else {
        for (var groupedBlock in groupedBlocks) {
          if (groupedBlock.first.id == block.id) {
            groupedBlock.add(block);
            found = true;
            break;
          }
        }
        if (!found) {
          groupedBlocks.add([block]);
        }
      }
    }
    for (var block in defaultGroup) {
      groupedBlocks.add([block]);
    }
    return groupedBlocks;
  }

  List<List<TimeBlock>> _mergeBlocksInColumns(List<TimeBlock> blocks) {
    var mergedBlocks = <List<TimeBlock>>[];
    // try to put blocks in the same column if the time doesn´t collide
    for (var block in blocks) {
      var mergeIndex = 0;

      for (var mergedBlock in mergedBlocks) {
        if (!mergedBlock.any((b) => b.collidesWith(block))) {
          mergedBlock.add(block);
          break;
        } else {
          mergeIndex++;
        }
      }
      if (mergedBlocks.length == mergeIndex) {
        mergedBlocks.add([block]);
      }
    }
    return mergedBlocks;
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
      text: TextSpan(text: '22:22', style: widget.theme.timeStyle),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout())
        .size;
  }
}
