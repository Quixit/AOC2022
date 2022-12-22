import 'package:d17/d17.dart';
import 'package:dartx/dartx.dart';

final sample = [
  ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>",
];

final input = /*readInput()*/ sample.first.codeUnits;

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

const maxRocks = 2022;

class LoopQueue<T> {
  LoopQueue(this.data);

  List<T> data;
  int index = 0;

  T get next {
    var result = data[index];

    index++;

    if (index >= data.length) index = 0;

    return result;
  }
}

var right = ">".codeUnitAt(0);
var left = "<".codeUnitAt(0);

//Note: unlike the other solutions, this time origin = bottom left.
void main(List<String> arguments) {
  var wind = LoopQueue(input);
  var shapes = LoopQueue(inputShapes);

  var maxHeight = 0;
  List<List<bool>> shaft = [];
  var rock = 1;
  while (rock <= maxRocks) {
    var shape = shapes.next;

    //Expand shaft.
    while (shaft.length < maxHeight + 3 + shape.length) {
      shaft.add(List.filled(7, false));
    }

    //place origin
    var origin = Vector(2, maxHeight + 4);

    //movement
    var moving = true;
    while (moving) {
      //Only calculate collisions if bottom of shape is adjacent to top of rocks.

      if (origin.y <= maxHeight + 1) {
        //check collision
        for (var y = 0; y < shape.length; y++) {
          for (var x = 0; x < shape.first.length; x++) {
            if (origin.y == 0 || shaft[origin.y + y - 1][origin.x + x]) {
              moving = false;
              y = shape.length;
              x = shape.first.length;
            }
          }
        }
      }

      if (moving) {
        //wind
        var direction = wind.next;

        if (direction == right) {
          if (origin.x < 7 - shape.first.length) {
            var canMove = true;

            if (origin.y <= maxHeight + 1) {
              for (var y = 0; y < shape.length; y++) {
                for (var x = 0; x < shape.first.length; x++) {
                  var compare = shaft[origin.y + y][origin.x + x + 1];

                  if (compare) {
                    canMove = false;
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
                  var compare = shaft[origin.y + y][origin.x + x - 1];

                  if (compare) {
                    canMove = false;
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

    maxHeight = origin.y + shape.length;

    rock++; //thank you, next.
  }

  print("Max height: $maxHeight");
}
