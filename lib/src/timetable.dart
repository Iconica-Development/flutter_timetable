part of timetable;

class Timetable extends StatefulWidget {
  const Timetable({
    this.timeBlocks = const [],
    this.scrollController,
    this.startHour = 0,
    this.endHour = 24,
    this.blockWidth = 50,
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
          ),
          Container(
            margin: const EdgeInsets.only(left: 45),
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
                        blockWidth: widget.blockWidth,
                        child: block.child,
                      )
                    ],
                    // TODO(anyone): 80 needs to be a calculated value
                    SizedBox(
                      width: 15,
                      height: 80 * (widget.endHour - widget.startHour) + 40,
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
      var initialOffset = (80 * (widget.endHour - widget.startHour)) *
          ((earliestStart.hour - widget.startHour) /
              (widget.endHour - widget.startHour));
      _scrollController.jumpTo(
        initialOffset,
      );
    });
  }
}
