part of timetable;

class Timetable extends StatefulWidget {
  const Timetable({
    this.scrollController,
    this.startHour = 0,
    this.endHour = 24,
    Key? key,
  }) : super(key: key);

  /// Hour at which the timetable starts.
  final int startHour;

  /// Hour at which the timetable ends.
  final int endHour;

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
        ],
      ),
    );
  }
}
