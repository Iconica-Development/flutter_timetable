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
      start: const TimeOfDay(hour: 14, minute: 0),
      end: const TimeOfDay(hour: 15, minute: 0),
      id: 0,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 8, minute: 0),
      end: const TimeOfDay(hour: 9, minute: 0),
      id: 1,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 9, minute: 15),
      end: const TimeOfDay(hour: 10, minute: 0),
      id: 1,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 10, minute: 15),
      end: const TimeOfDay(hour: 11, minute: 0),
      child: Container(color: Colors.purple, height: 300, width: 50),
      childDimension: 300,
      id: 2,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 6, minute: 15),
      end: const TimeOfDay(hour: 7, minute: 0),
      child: Container(color: Colors.blue, height: 300, width: 300),
      childDimension: 300,
      id: 2,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 18, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 30),
      child:
          const SizedBox(width: 60, height: 60, child: const Text('High Tea')),
      childDimension: 60,
      id: 10,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 18, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 30),
      child: const SizedBox(
        height: 60,
        width: 60,
        child: const Text('High Tea'),
      ),
      childDimension: 60,
      id: 10,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 18, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 30),
      child: const SizedBox(
        height: 60,
        width: 60,
        child: const Text('High Tea'),
      ),
      childDimension: 60,
      id: 10,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 18, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 30),
      child: const SizedBox(
        height: 50,
        width: 50,
        child: const Text('High Tea'),
      ),
      childDimension: 60,
      id: 0,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 14, minute: 0),
      end: const TimeOfDay(hour: 15, minute: 0),
      id: 100,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 14, minute: 0),
      end: const TimeOfDay(hour: 15, minute: 0),
      id: 101,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 14, minute: 0),
      end: const TimeOfDay(hour: 15, minute: 0),
      id: 102,
    ),
    TimeBlock(
      start: const TimeOfDay(hour: 14, minute: 0),
      end: const TimeOfDay(hour: 15, minute: 0),
      id: 103,
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
          child: Column(
            children: [
              // toggle between horizontal and vertical
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _horizontal = !_horizontal;
                      });
                    },
                    child: Text(_horizontal ? 'Horizontal' : 'Vertical'),
                  ),
                ],
              ),
              // toggle between grouped and ungrouped blocks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
              Timetable(
                tableDirection: _horizontal ? Axis.horizontal : Axis.vertical,
                startHour: 3,
                endHour: 22,
                timeBlocks: blocks,
                scrollController: _scrollController,
                combineBlocks: true,
                mergeBlocks: _grouped,
                theme: const TableTheme(
                  tablePaddingStart: 0,
                  blockPaddingBetween: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
