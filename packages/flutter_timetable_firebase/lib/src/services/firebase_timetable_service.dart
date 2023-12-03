import 'package:flutter/material.dart';
import 'package:flutter_timetable_firebase/src/config/firebase_timetable_options.dart';
import 'package:flutter_timetable_interface/flutter_timetable_interface.dart';

class FirebaseTimetableService<Event>
    with ChangeNotifier
    implements TimetableService<Event> {
  FirebaseTimetableService({
    required this.options,
  });

  final FirebaseTimetableOptions options;

  @override
  Future<void> addEvent(event) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> checkForConflict(event, DateTime day) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEvent(Event event) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Event>> fetchEventsForDay(DateTime day) async {
    throw UnimplementedError();
  }

  @override
  List<Event> getEventsForDay(DateTime day) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateEvent(Event event) async {
    throw UnimplementedError();
  }
}
