import 'package:flutter/material.dart';
import 'package:timetable/timetable.dart';

void main() {
  runApp(const MaterialApp(home: TimetableDemo()));
}

class TimetableDemo extends StatelessWidget {
  const TimetableDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Timetable());
  }
}
