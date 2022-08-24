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
                      for (var block in widget.timeBlocks) ...[
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
                      for (var blocks
                          in _mergeBlocksInColumns(widget.timeBlocks)) ...[
                        Stack(
                          children: [
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
                          ],
                        ),
                      ]
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
