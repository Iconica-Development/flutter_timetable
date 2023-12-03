import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timetable_firebase/src/config/firebase_timetable_options.dart';
import 'package:flutter_timetable_interface/flutter_timetable_interface.dart';

class FirebaseTimetableService<Event extends TimetableEvent>
    with ChangeNotifier
    implements TimetableService<Event> {
  FirebaseTimetableService({
    FirebaseApp? app,
    options = const FirebaseTimetableOptions(),
  }) {
    var appInstance = app ?? Firebase.app();
    _db = FirebaseFirestore.instanceFor(app: appInstance);
    _options = options;
  }

  late FirebaseTimetableOptions _options;
  late FirebaseFirestore _db;

  @override
  Future<void> addEvent(Event event) async {
    event.toJson();
  
    throw UnimplementedError();
  }

  @override
  Future<bool> checkForConflict(Event event, DateTime day) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEvent(Event event) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Event>> fetchEventsForDay(DateTime day,
      {String? category}) async {
    throw UnimplementedError();
  }

  @override
  List<Event> getEventsForDay(DateTime day, {String? category}) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateEvent(Event event) async {
    throw UnimplementedError();
  }
}
