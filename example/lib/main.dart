// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:timetable/timetable.dart';

void main() {
  runApp(const MaterialApp(home: TimetableDemo()));
}

class TimetableDemo extends StatefulWidget {
  const TimetableDemo({Key? key}) : super(key: key);

  @override
  State<TimetableDemo> createState() => _TimetableDemoState();
}

class _TimetableDemoState extends State<TimetableDemo> {
  bool _grouped = false;
  bool _horizontal = true;
  final ScrollController _scrollController = ScrollController();
  final List<TimeBlock> blocks = [
    TimeBlock(
      start: const TimeOfDay(hour: 8, minute: 0),
      end: const TimeOfDay(hour: 9, minute: 0),
      child: Container(
        color: Colors.red,
        child: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Exercise',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      id: 1,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 10, minute: 0),
      end: const TimeOfDay(hour: 12, minute: 0),
      child: Container(
        color: Colors.orange,
        child: const Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Brunch',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      childDimension: 300,
      id: 3,
    ),
    TimeBlock(
        start: const TimeOfDay(hour: 14, minute: 0),
        end: const TimeOfDay(hour: 15, minute: 0),
        id: 100,
        child: const SizedBox(
          height: 300,
          child: Text(
            'Clean Living Room',
            style: TextStyle(color: Colors.white),
          ),
        )),
    TimeBlock(
        start: const TimeOfDay(hour: 14, minute: 0),
        end: const TimeOfDay(hour: 15, minute: 0),
        id: 101,
        child: const SizedBox(
          height: 200,
          child: Text(
            'Clean Kitchen',
            style: TextStyle(color: Colors.white),
          ),
        )),
    TimeBlock(
      start: const TimeOfDay(hour: 14, minute: 0),
      end: const TimeOfDay(hour: 15, minute: 0),
      id: 102,
      child: const SizedBox(
        height: 100,
        child: Text(
          'Clean Bathroom',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 14, minute: 0),
      end: const TimeOfDay(hour: 15, minute: 0),
      id: 103,
      child: const SizedBox(
        height: 50,
        child: Text(
          'Clean Toilet',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable Demo'),
      ),
      // backgroundColor: Colors.green,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // toggle between horizontal and vertical
                const Text('Axis horizontal'),
                Switch(
                  value: _horizontal,
                  onChanged: (value) {
                    setState(() {
                      _horizontal = value;
                    });
                  },
                ),
                // toggle between grouped and ungrouped blocks
                const Text('Grouped'),
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
          ),
          Container(
            color: Colors.white,
            child: Timetable(
              size: Size(size.width, size.height * 0.64),
              tableDirection: _horizontal ? Axis.horizontal : Axis.vertical,
              startHour: 3,
              endHour: 24,
              timeBlocks: blocks,
              scrollController: _scrollController,
              combineBlocks: true,
              mergeBlocks: _grouped,
              theme: const TableTheme(
                tablePaddingStart: 0,
                blockPaddingBetween: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
