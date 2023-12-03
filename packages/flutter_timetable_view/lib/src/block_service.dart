// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/src/models/time_block.dart';

/// Combine blocks that have the same id and the same time.
List<TimeBlock> combineBlocksWithId(List<TimeBlock> blocks) {
  var newBlocks = <TimeBlock>[];
  var groupedBlocks = <List<TimeBlock>>[];
  for (var block in blocks) {
    var found = false;
    if (block.id == 0) {
      newBlocks.add(block);
      found = true;
    } else {
      found = _checkIfBlockWithIdExists(groupedBlocks, block);
    }

    if (!found) {
      if (blocks
          .where(
            (b) =>
                b != block &&
                b.id == block.id &&
                b.start == block.start &&
                b.end == block.end,
          )
          .isNotEmpty) {
        groupedBlocks.add([block]);
      } else {
        newBlocks.add(block);
      }
    }
  }

  _combineGroupedBlocks(groupedBlocks, newBlocks);
  return newBlocks;
}

void _combineGroupedBlocks(
  List<List<TimeBlock>> groupedBlocks,
  List<TimeBlock> newBlocks,
) {
  for (var block in groupedBlocks) {
    var startMinute = block.first.start.minute +
        block.first.start.hour * Duration.minutesPerHour;
    var endMinute =
        block.first.end.minute + block.first.end.hour * Duration.minutesPerHour;
    var durationMinute = (endMinute - startMinute) * block.length;

    var endTime = TimeOfDay(
      hour: (startMinute + durationMinute) ~/ Duration.minutesPerHour,
      minute: (startMinute + durationMinute) % Duration.minutesPerHour,
    );
    var newBlock = TimeBlock(
      start: block.first.start,
      end: endTime,
      id: block.first.id,
      // combine the childDimension of all the children
      childDimension: block.fold(
        0.0,
        (previousValue, element) =>
            (previousValue ?? 0.0) + (element.childDimension ?? 0.0),
      ),
      child: Column(
        children: [
          for (var b in block) ...[b.child ?? Container()],
        ],
      ),
    );
    newBlocks.add(newBlock);
  }
}

bool _checkIfBlockWithIdExists(
  List<List<TimeBlock>> groupedBlocks,
  TimeBlock block,
) {
  for (var groupedBlock in groupedBlocks) {
    if (groupedBlock.first.id == block.id &&
        groupedBlock.first.start == block.start &&
        groupedBlock.first.end == block.end) {
      groupedBlock.add(block);
      return true;
    }
  }
  return false;
}

/// Group blocks with the same id together.
/// Items in the same group will be displayed in the same column.
List<List<TimeBlock>> groupBlocksById(List<TimeBlock> blocks) {
  var groupedBlocks = <List<TimeBlock>>[];
  var defaultGroup = <TimeBlock>[];
  for (var block in blocks) {
    var found = false;
    if (block.id == 0) {
      defaultGroup.add(block);
    } else {
      for (var groupedBlock in groupedBlocks) {
        if (groupedBlock.first.id == block.id) {
          groupedBlock.add(block);
          found = true;
          break;
        }
      }
      if (!found) {
        groupedBlocks.add([block]);
      }
    }
  }
  for (var block in defaultGroup) {
    groupedBlocks.add([block]);
  }
  return groupedBlocks;
}

/// Merge blocks that fit below eachother into one column.
List<List<TimeBlock>> mergeBlocksInColumns(List<TimeBlock> blocks) {
  var mergedBlocks = <List<TimeBlock>>[];
  for (var block in blocks) {
    var mergeIndex = 0;

    for (var mergedBlock in mergedBlocks) {
      if (!mergedBlock.any((b) => b.collidesWith(block))) {
        mergedBlock.add(block);
        break;
      } else {
        mergeIndex++;
      }
    }
    if (mergedBlocks.length == mergeIndex) {
      mergedBlocks.add([block]);
    }
  }
  return mergedBlocks;
}
