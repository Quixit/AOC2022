import 'package:d14/d14.dart';
import 'dart:collection';

final sample = ["498,4 -> 498,6 -> 496,6", "503,4 -> 502,4 -> 502,9 -> 494,9"];

final input = readInput();

enum SimObject { nothing, rock, sand }

const simX = 1000;
const simY = 200;

void main(List<String> arguments) {
  var grid =
      List.generate(simX, (index) => List.filled(simX, SimObject.nothing));
  var lowest = 0;
  var count = 0;
  var simulate = true;

  for (var element in input) {
    var instructions = element.split(" -> ");
    var last = instructions.first.split(",").map((e) => int.parse(e)).toList();

    for (var i = 1; i < instructions.length; i++) {
      var current =
          instructions[i].split(",").map((e) => int.parse(e)).toList();

      if (last[0] == current[0]) {
        //X Same
        var x = last[0];
        var from = last[1] < current[1] ? last[1] : current[1];
        var to = last[1] < current[1] ? current[1] : last[1];

        for (var y = from; y <= to; y++) {
          grid[x][y] = SimObject.rock;

          if (y > lowest) lowest = y;
        }
      } else if (last[1] == current[1]) {
        //Y Same
        var y = last[1];
        var from = last[0] < current[0] ? last[0] : current[0];
        var to = last[0] < current[0] ? current[0] : last[0];

        for (var x = from; x <= to; x++) {
          grid[x][y] = SimObject.rock;
        }

        if (y > lowest) lowest = y;
      } else {
        throw Exception("The instructions is a lie!");
      }

      last = current;
    }
  }

  //Draw Floor
  for (var x = 0; x < simX; x++) {
    grid[x][lowest + 2] = SimObject.rock;
  }

  var first = true;
  //Simulate sand
  while (simulate) {
    var current = Vector(500, 0);

    while (true) {
      if (grid[current.x][current.y + 1] == SimObject.nothing) {
        current.y++;
      } else if (grid[current.x - 1][current.y + 1] == SimObject.nothing) {
        current.y++;
        current.x--;
      } else if (grid[current.x + 1][current.y + 1] == SimObject.nothing) {
        current.y++;
        current.x++;
      } else {
        grid[current.x][current.y] = SimObject.sand;

        if (current.x == 500 && current.y == 0) {
          simulate = false;
          print("${count + 1} units come to rest before blocking the hole.");
        }

        break;
      }

      //check for falling off.
      if (current.y > lowest && first) {
        print("$count units come to rest before oblivion.");
        first = false;
      }
    }

    count++;
  }
}
