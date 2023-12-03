import 'package:flutter/material.dart';

abstract class TimetableService<Event> with ChangeNotifier {
  Future<List<Event>> fetchEventsForDay(DateTime day);
  List<Event> getEventsForDay(DateTime day);
  Future<void> addEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(Event event);
  Future<bool> checkForConflict(Event event, DateTime day);
}
