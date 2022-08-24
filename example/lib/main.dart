import 'package:flutter/material.dart';
import 'package:timetable/timetable.dart';

void main() {
  runApp(MaterialApp(home: TimetableDemo()));
}

class TimetableDemo extends StatefulWidget {
  const TimetableDemo({Key? key}) : super(key: key);

  @override
  State<TimetableDemo> createState() => _TimetableDemoState();
}

class _TimetableDemoState extends State<TimetableDemo> {
  final ScrollController _scrollController = ScrollController();
  final List<TimeBlock> blocks = [
    TimeBlock(
      start: TimeOfDay(hour: 8, minute: 0),
      end: TimeOfDay(hour: 9, minute: 0),
      child: null,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 9, minute: 15),
      end: TimeOfDay(hour: 10, minute: 0),
      child: null,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 10, minute: 15),
      end: TimeOfDay(hour: 11, minute: 0),
      child: Container(color: Colors.purple, height: 300, width: 50),
    ),
    TimeBlock(
      start: TimeOfDay(hour: 6, minute: 15),
      end: TimeOfDay(hour: 7, minute: 0),
      child: Container(color: Colors.blue, height: 300, width: 200),
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Timetable(
          startHour: 3,
          endHour: 22,
          timeBlocks: blocks,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}
