import 'package:d09/d09.dart';
import 'dart:collection';

final sample = ["R 4", "U 4", "L 3", "D 1", "R 4", "D 1", "L 5", "R 2"]
    .map((e) => Instruction(e.split(" ")[0], int.parse(e.split(" ")[1])))
    .toList();

final input = readInput()
    .map((e) => Instruction(e.split(" ")[0], int.parse(e.split(" ")[1])))
    .toList();

class Instruction {
  Instruction(this.direction, this.value);

  String direction;
  int value;
}

class Vector {
  Vector(this.X, this.Y);

  int X;
  int Y;
}

int getLocations(int quantity) {
  var tailLocations = HashSet<String>();
  var head = Vector(0, 0);
  List<Vector> tails = [];

  for (var i = 0; i < quantity; i++) {
    tails.add(Vector(0, 0));
  }

  tailLocations.add("0-0");

  for (var instruction in input) {
    for (var i = 0; i < instruction.value; i++) {
      switch (instruction.direction) {
        case "U":
          head.Y--;
          break;
        case "D":
          head.Y++;
          break;
        case "L":
          head.X--;
          break;
        case "R":
          head.X++;
          break;
      }

      var last = head;

      for (var x = 0; x < tails.length; x++) {
        var tail = tails[x];

        if ((tail.X - last.X).abs() > 1 || (tail.Y - last.Y).abs() > 1) {
          //Has to move.

          if (tail.Y != last.Y) {
            // must move Y
            if (last.Y > tail.Y) {
              tail.Y++;
            } else {
              tail.Y--;
            }
          }

          if (tail.X != last.X) {
            // must move X
            if (last.X > tail.X) {
              tail.X++;
            } else {
              tail.X--;
            }
          }

          if (x == tails.length - 1) {
            //only the last one matters.
            tailLocations.add("${tail.X}-${tail.Y}");
          }
        }

        last = tail;
      }
    }
  }
  return tailLocations.length;
}

void main(List<String> arguments) {
  print("Tail Locations: ${getLocations(1)}");
  print("9 Step Tail Locations: ${getLocations(9)}");
}
