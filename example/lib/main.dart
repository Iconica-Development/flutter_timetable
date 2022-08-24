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
  bool _grouped = false;
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
    TimeBlock(
      start: TimeOfDay(hour: 18, minute: 0),
      end: TimeOfDay(hour: 18, minute: 15),
      child: Text('High Tea'),
      id: 10,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 18, minute: 0),
      end: TimeOfDay(hour: 18, minute: 15),
      child: Text('High Tea'),
      id: 10,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 18, minute: 0),
      end: TimeOfDay(hour: 18, minute: 15),
      child: Text('High Tea'),
      id: 10,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 18, minute: 0),
      end: TimeOfDay(hour: 18, minute: 15),
      child: Text('High Tea'),
      id: 0,
    ),
  ];

  final List<TimeBlock> groupedBlocks = [
    TimeBlock(
      start: TimeOfDay(hour: 14, minute: 0),
      end: TimeOfDay(hour: 15, minute: 0),
      id: 0,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 8, minute: 0),
      end: TimeOfDay(hour: 9, minute: 0),
      id: 1,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 9, minute: 15),
      end: TimeOfDay(hour: 10, minute: 0),
      id: 1,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 10, minute: 15),
      end: TimeOfDay(hour: 11, minute: 0),
      child: Container(color: Colors.purple, height: 300, width: 50),
      id: 2,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 6, minute: 15),
      end: TimeOfDay(hour: 7, minute: 0),
      child: Container(color: Colors.blue, height: 300, width: 200),
      id: 2,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 18, minute: 0),
      end: TimeOfDay(hour: 18, minute: 15),
      child: Text('High Tea'),
      id: 10,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 18, minute: 0),
      end: TimeOfDay(hour: 18, minute: 15),
      child: Text('High Tea'),
      id: 10,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 18, minute: 0),
      end: TimeOfDay(hour: 18, minute: 15),
      child: Text('High Tea'),
      id: 10,
    ),
    TimeBlock(
      start: TimeOfDay(hour: 18, minute: 0),
      end: TimeOfDay(hour: 18, minute: 15),
      child: Text('High Tea'),
      id: 0,
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
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // toggle between grouped and ungrouped blocks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Grouped'),
                  Switch(
                    value: _grouped,
                    onChanged: (value) {
                      setState(() {
                        _grouped = value;
                      });
                    },
                  ),
                ],
              ),
              if (_grouped) ...[
                Timetable(
                  startHour: 3,
                  endHour: 22,
                  timeBlocks: groupedBlocks,
                  scrollController: _scrollController,
                  tablePaddingStart: 0,
                  collapseBlocks: true,
                )
              ] else ...[
                Timetable(
                  startHour: 3,
                  endHour: 22,
                  timeBlocks: blocks,
                  scrollController: _scrollController,
                  tablePaddingStart: 0,
                  collapseBlocks: true,
                  mergeBlocks: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
