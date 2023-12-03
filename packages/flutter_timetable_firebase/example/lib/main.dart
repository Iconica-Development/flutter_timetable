import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_timetable_firebase/flutter_timetable_firebase.dart';
import 'package:flutter_timetable_interface/flutter_timetable_interface.dart';

class MyRosterModel extends TimetableEvent {
  const MyRosterModel({
    required super.end,
    required super.start,
    required super.entityId,
    required super.eventId,
    this.isSick = false,
  });

  final bool isSick;
}

final myRosterServiceProvider = Provider(
  (ref) => FirebaseTimetableService<MyRosterModel>(
    options: FirebaseTimetableOptions(timelineCollectionName: 'roster'),
  ),
);

void main() {}
