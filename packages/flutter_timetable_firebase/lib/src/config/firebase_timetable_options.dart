// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class FirebaseTimetableOptions {
  const FirebaseTimetableOptions({
    this.timelineCollectionName = 'timetable',
  });

  final String timelineCollectionName;
}

enum FirebaseTimetableServiceStrategy {
  alwaysFetch,
  fetchOnce,
  fetchOnceAndListen,
  listen,
}
