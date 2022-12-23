import 'dart:ffi';
import 'dart:math';

import 'package:d17/d17.dart';
import 'package:dartx/dartx.dart';

final sample = [
  ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>",
];

final input = readInput().first.codeUnits;

const inputShapes = [
  [
    [true, true, true, true]
  ],
  [
    [false, true, false],
    [true, true, true],
    [false, true, false]
  ],
  [
    [true, true, true],
    [false, false, true],
    [false, false, true]
  ],
  [
    [true],
    [true],
    [true],
    [true]
  ],
  [
    [true, true],
    [true, true]
  ]
];

draw(List<List<bool>> shaft) {
  for (var y = shaft.length - 1; y >= 0; y--) {
    var line = "|";
    for (var x = 0; x < shaft.first.length; x++) {
      line += (shaft[y][x] ? "#" : ".");
    }
    line += "|";
    print(line);
  }

  print("+-------+");
  print("");
}

var right = ">".codeUnitAt(0);
var left = "<".codeUnitAt(0);

//Note: unlike the other solutions, this time origin = bottom left.
void main(List<String> arguments) {
  var maxHeight = simulate(2022);

  print("Max height: $maxHeight");

  maxHeight = simulate(1000000000000);

  print("Stupid Elephants: $maxHeight");
}

class State {
  State(this.rocks, this.height);

  int rocks;
  int height;
}

int simulate(int maxRocks) {
  var wind = LoopQueue(input);
  var shapes = LoopQueue(inputShapes);
  Map<String, State> states = {};

  var maxHeight = 0;
  var cycleHeight = 0;
  List<List<bool>> shaft = [];
  var rock = 1;
  while (rock <= maxRocks) {
    var shape = shapes.next;

    //Expand shaft.
    while (shaft.length < maxHeight + 3 + shape.length) {
      shaft.add(List.filled(7, false));
    }

    //place origin
    var origin = Vector(2, maxHeight + 3);

    //movement
    var moving = true;
    while (moving) {
      //Only calculate collisions if bottom of shape is adjacent to top of rocks.

      //wind
      var direction = wind.next;

      if (direction == right) {
        if (origin.x < 7 - shape.first.length) {
          var canMove = true;

          if (origin.y <= maxHeight + 1) {
            for (var y = 0; y < shape.length; y++) {
              for (var x = 0; x < shape.first.length; x++) {
                if (shape[y][x]) {
                  var compare = shaft[origin.y + y][origin.x + x + 1];

                  if (compare) {
                    canMove = false;
                  }
                }
              }
            }
          }

          if (canMove) {
            origin.x++;
          }
        }
      } else if (direction == left) {
        if (origin.x > 0) {
          var canMove = true;

          if (origin.y <= maxHeight + 1) {
            for (var y = 0; y < shape.length; y++) {
              for (var x = 0; x < shape.first.length; x++) {
                if (shape[y][x]) {
                  var compare = shaft[origin.y + y][origin.x + x - 1];

                  if (compare) {
                    canMove = false;
                  }
                }
              }
            }
          }

          if (canMove) {
            origin.x--;
          }
        }
      } else {
        throw Exception("Direction logic wrong.");
      }

      //down
      if (origin.y <= maxHeight + 1) {
        //check collision
        for (var y = 0; y < shape.length; y++) {
          for (var x = 0; x < shape.first.length; x++) {
            if (shape[y][x]) {
              if (origin.y == 0 || shaft[origin.y + y - 1][origin.x + x]) {
                moving = false;
                y = shape.length;
                x = shape.first.length;
              }
            }
          }
        }
      }

      if (moving) {
        origin.y--;
      }
    }

    //draw at origin;
    for (var y = 0; y < shape.length; y++) {
      for (var x = 0; x < shape.first.length; x++) {
        if (shape[y][x]) {
          shaft[origin.y + y][origin.x + x] = true;
        }
      }
    }

    var rest = origin.y + shape.length;
    maxHeight = rest > maxHeight ? rest : maxHeight;

    rock++; //thank you, next.

    //Look for cycles.
    if (maxHeight > 7) {
      var toplines = shaft.skip(maxHeight - 8).take(8).fold<Iterable<bool>>([],
          (previousValue, element) => previousValue.append(element)).toList();

      var top = 0;

      for (var i = 0; i < 8; i++) {
        top += toplines[i] ? 2 ^ i : 0;
      }

      var compare = String.fromCharCodes([top, shapes.index, wind.index]);
      var state = states[compare];

      if (state != null) {
        var repeatLength = rock - state.rocks;
        var repeats = ((maxRocks - rock) / repeatLength).floor();
        rock += repeatLength * repeats;
        cycleHeight += repeats * (maxHeight - state.height);

        states.clear();
      } else {
        states[compare] = State(rock, maxHeight);
      }
    }
  }

  return maxHeight + cycleHeight;
}
