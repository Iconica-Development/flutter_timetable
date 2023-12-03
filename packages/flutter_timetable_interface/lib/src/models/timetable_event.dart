// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

@immutable
class TimetableEvent {
  /// The model used for a [Block] in a [TimeTable] which can contain a Widget.
  const TimetableEvent({
    required this.start,
    required this.end,
    required this.entityId,
    required this.eventId,
  });

  /// The date at which the event starts
  final DateTime start;

  /// The date at which the event ends
  final DateTime end;

  /// The unique identifier of the event
  /// This is used to store the events
  final String eventId;

  /// The identifier of the entity that the event belongs to
  /// This is used to check for conflicts between entities
  final String entityId;
}
