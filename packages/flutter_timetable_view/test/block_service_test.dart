// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_timetable_interface/flutter_timetable_interface.dart';
import 'package:flutter_timetable_view/src/block_service.dart';

void main() {
  group('test combineBlocksWithId', () {
    test('new block creation success', () {
      //Arrange
      var blocks = [
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 2, minute: 15),
          id: 5,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 2, minute: 15),
          id: 5,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 15),
          end: const TimeOfDay(hour: 2, minute: 30),
          id: 6,
        ),
      ];

      //Act
      var result = combineBlocksWithId(blocks);

      //Assert
      expect(result.length, 2);
      expect(
        result.firstWhere((element) => element.id == 5).end,
        const TimeOfDay(hour: 2, minute: 30),
      );
    });

    test('elements without id ignored', () {
      //Arrange
      var blocks = [
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 2, minute: 15),
          id: 0, // default id is 0
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 2, minute: 15),
          id: 0,
        ),
      ];

      //Act
      var result = combineBlocksWithId(blocks);

      //Assert
      expect(result.length, 2);
      expect(result.first.end, const TimeOfDay(hour: 2, minute: 15));
    });
  });

  group('test groupBlocksById', () {
    test('groupBlocksById success', () {
      //Arrange
      var blocks = [
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 2, minute: 15),
          id: 5,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 2, minute: 25),
          id: 5,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 20),
          end: const TimeOfDay(hour: 2, minute: 30),
          id: 6,
        ),
      ];

      //Act
      var result = groupBlocksById(blocks);

      //Assert
      expect(result.length, 2);
    });

    test('groupBlocksById id 0 ignored', () {
      // Arrange
      var blocks = [
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 2, minute: 15),
          id: 0,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 2, minute: 25),
          id: 0,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 20),
          end: const TimeOfDay(hour: 2, minute: 30),
          id: 0,
        ),
      ];

      //Act
      var result = groupBlocksById(blocks);

      //Assert
      expect(result.length, 3);
    });
  });

  group('test mergeBlocksInColumns', () {
    test('mergeBlocksInColumns success', () {
      //Arrange
      var blocks = [
        TimeBlock(
          start: const TimeOfDay(hour: 2, minute: 0),
          end: const TimeOfDay(hour: 6, minute: 15),
          id: 1,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 8, minute: 0),
          end: const TimeOfDay(hour: 10, minute: 25),
          id: 2,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 12, minute: 20),
          end: const TimeOfDay(hour: 14, minute: 30),
          id: 3,
        ),
        TimeBlock(
          start: const TimeOfDay(hour: 13, minute: 20),
          end: const TimeOfDay(hour: 14, minute: 15),
          id: 4,
        ),
      ];

      //Act
      var result = mergeBlocksInColumns(blocks);

      //Assert
      expect(result.length, 2);
    });
  });
}
