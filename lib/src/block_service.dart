part of timetable;

/// Combine blocks that have the same id and the same time.
List<TimeBlock> collapseBlocks(List<TimeBlock> blocks) {
  var newBlocks = <TimeBlock>[];
  var groupedBlocks = <List<TimeBlock>>[];
  // order blocks by id and collides with another block
  for (var block in blocks) {
    // check if the block is already in one of the grouped blocks
    var found = false;
    if (block.id == 0) {
      newBlocks.add(block);
      continue;
    }
    for (var groupedBlock in groupedBlocks) {
      if (groupedBlock.first.id == block.id &&
          groupedBlock.first.start == block.start &&
          groupedBlock.first.end == block.end) {
        groupedBlock.add(block);
        found = true;
        break;
      }
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

  for (var block in groupedBlocks) {
    // combine the blocks into one block
    // calculate the endtime of the combined block
    var startMinute = block.first.start.minute + block.first.start.hour * 60;
    var endMinute = block.first.end.minute + block.first.end.hour * 60;
    var durationMinute = (endMinute - startMinute) * block.length;

    var endTime = TimeOfDay(
      hour: (startMinute + durationMinute) ~/ 60,
      minute: (startMinute + durationMinute) % 60,
    );
    var newBlock = TimeBlock(
      start: block.first.start,
      end: endTime,
      id: block.first.id,
      child: Column(
        children: [
          for (var b in block) ...[b.child ?? Container()],
        ],
      ),
    );
    newBlocks.add(newBlock);
  }
  return newBlocks;
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

/// Nerge blocks that fit below eachother into one column.
List<List<TimeBlock>> mergeBlocksInColumns(List<TimeBlock> blocks) {
  var mergedBlocks = <List<TimeBlock>>[];
  // try to put blocks in the same column if the time doesn´t collide
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
