import 'dart:developer';
import 'dart:math';

import 'package:d08/d08.dart';
import 'dart:collection';

final sample = [
  "30373",
  "25512",
  "65332",
  "33549",
  "35390",
]
    .map((e) =>
        e.codeUnits.map((e) => int.parse(String.fromCharCode(e))).toList())
    .toList();

final input = readInput()
    .map((e) =>
        e.codeUnits.map((e) => int.parse(String.fromCharCode(e))).toList())
    .toList();

enum Direction { up, down, left, right }

bool checkValue(int value, int y, int x, Direction direction) {
  if (y < 0 || x < 0 || y >= input.length || x >= input[0].length) {
    return true; //at edge.
  } else if (input[y][x] >= value) {
    return false;
  }

  switch (direction) {
    case Direction.up:
      return checkValue(value, y - 1, x, direction);
    case Direction.down:
      return checkValue(value, y + 1, x, direction);
    case Direction.left:
      return checkValue(value, y, x - 1, direction);
    case Direction.right:
      return checkValue(value, y, x + 1, direction);
  }
}

int checkScore(int value, int y, int x, Direction direction, int count) {
  if (y < 0 || x < 0 || y >= input.length || x >= input[0].length) {
    return count; //at edge.
  } else if (input[y][x] >= value) {
    return count + 1;
  }

  switch (direction) {
    case Direction.up:
      return checkScore(value, y - 1, x, direction, count + 1);
    case Direction.down:
      return checkScore(value, y + 1, x, direction, count + 1);
    case Direction.left:
      return checkScore(value, y, x - 1, direction, count + 1);
    case Direction.right:
      return checkScore(value, y, x + 1, direction, count + 1);
  }
}

void main(List<String> arguments) {
  var visible = 0;
  var maxScore = 0;

  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      if (checkValue(input[y][x], y - 1, x, Direction.up) ||
          checkValue(input[y][x], y + 1, x, Direction.down) ||
          checkValue(input[y][x], y, x - 1, Direction.left) ||
          checkValue(input[y][x], y, x + 1, Direction.right)) {
        visible++;
      }

      var score = checkScore(input[y][x], y - 1, x, Direction.up, 0) *
          checkScore(input[y][x], y + 1, x, Direction.down, 0) *
          checkScore(input[y][x], y, x - 1, Direction.left, 0) *
          checkScore(input[y][x], y, x + 1, Direction.right, 0);

      if (score > maxScore) {
        maxScore = score;
      }
    }
  }

  print("Visible trees: $visible");
  print("Max score: $maxScore");
}
