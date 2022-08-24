part of timetable;

class Timetable extends StatefulWidget {
  const Timetable({
    this.timeBlocks = const [],
    this.scrollController,
    this.startHour = 0,
    this.endHour = 24,
    this.blockWidth = 50,
    this.blockColor = const Color(0x80FF0000),
    this.hourHeight = 80,
    this.tablePaddingStart = 10,
    this.tablePaddingEnd = 15,
    this.theme = const TableTheme(),
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
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      child: Stack(
        children: [
          Table(
            startHour: widget.startHour,
            endHour: widget.endHour,
            theme: widget.theme,
          ),
          Container(
            margin: EdgeInsets.only(
              left: _calculateTableTextSize().width +
                  widget.tablePaddingStart +
                  5,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var block in widget.timeBlocks) ...[
                      Block(
                        start: block.start,
                        end: block.end,
                        startHour: widget.startHour,
                        hourHeight: widget.hourHeight,
                        blockWidth: widget.blockWidth,
                        child: block.child,
                      ),
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

  /// Calculates the width of 22:22
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
