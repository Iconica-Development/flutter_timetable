// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class FirebaseTimetableOptions {
  const FirebaseTimetableOptions({
    this.timetableCollectionName = 'timetable',
    this.cachingStrategy = TimetableCachingStrategy.alwaysFetch,
  });
  // the collection reference name
  final String timetableCollectionName;

  /// Changes the Firebase Timetable Service to use different caching approaches
  final TimetableCachingStrategy cachingStrategy;
}

enum TimetableCachingStrategy {
  // Everytime the timetable is requested it will be fetched from the database
  alwaysFetch,
  // if you use fetchOnce the timetable events will be fetched only once
  fetchOnce,
  // will first be fetched and after that updates will be listened to
  fetchOnceAndListen,
  // if you use listen the timetable events will be updated in real time
  listen,
}
