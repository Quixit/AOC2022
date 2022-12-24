import 'package:d18/d18.dart';
import 'package:dartx/dartx.dart';

final sample = [
  "2,2,2",
  "1,2,2",
  "3,2,2",
  "2,1,2",
  "2,3,2",
  "2,2,1",
  "2,2,3",
  "2,2,4",
  "2,2,6",
  "1,2,5",
  "3,2,5",
  "2,1,5",
  "2,3,5",
];

final input = readInput()
    .map((e) => e.split(","))
    .map((e) => Vector3D(int.parse(e[0]), int.parse(e[1]), int.parse(e[2])));

void main(List<String> arguments) {
  Map<String, bool> grid = {};
  var exterior = 0;

  for (var cube in input) {
    exterior += 6;

    //check covered
    if (grid[(cube + Vector3D(1, 0, 0)).key] == true) {
      exterior -= 2;
    }
    if (grid[(cube + Vector3D(-1, 0, 0)).key] == true) {
      exterior -= 2;
    }

    if (grid[(cube + Vector3D(0, 1, 0)).key] == true) {
      exterior -= 2;
    }
    if (grid[(cube + Vector3D(0, -1, 0)).key] == true) {
      exterior -= 2;
    }

    if (grid[(cube + Vector3D(0, 0, 1)).key] == true) {
      exterior -= 2;
    }
    if (grid[(cube + Vector3D(0, 0, -1)).key] == true) {
      exterior -= 2;
    }

    //Add
    grid[cube.key] = true;
  }

  print("Surface area $exterior.");
}
