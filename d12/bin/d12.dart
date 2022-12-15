import 'package:d12/d12.dart';
import 'dart:collection';

final sample = [
  "Sabqponm",
  "abcryxxl",
  "accszExk",
  "acctuvwj",
  "abdefghi",
];

final input = readInput();

int getHeight(String char) {
  return (char == "E" ? "z" : (char == "S" ? "a" : char)).codeUnitAt(0);
}

void main(List<String> arguments) {
  var points = input.length * input[0].length;

  List<List<int>> graph = List.filled(points, []);

  for (var i = 0; i < points; i++) {
    graph[i] = List.filled(points, 0);
  }

  int start = 0;
  int end = 0;
  int current = 0;
  List<int> lowest = [];

  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[y].length; x++) {
      if (input[y][x] == "S") {
        start = current;
      } else if (input[y][x] == "E") {
        end = current;
      }

      var height = getHeight(input[y][x]);

      //Up
      if (y > 0) {
        var unit = getHeight(input[y - 1][x]);

        if (unit <= height + 1) {
          graph[current][current - input[0].length] = 1;
        }
      }

      //Down
      if (y < input.length - 1) {
        var unit = getHeight(input[y + 1][x]);

        if (unit <= height + 1) {
          graph[current][current + input[0].length] = 1;
        }
      }

      //Left
      if (x > 0) {
        var unit = getHeight(input[y][x - 1]);

        if (unit <= height + 1) {
          graph[current][current - 1] = 1;
        }
      }

      //Right
      if (x < input[0].length - 1) {
        var unit = getHeight(input[y][x + 1]);

        if (unit <= height + 1) {
          graph[current][current + 1] = 1;
        }
      }

      if (input[y][x] == "a") {
        lowest.add(current);
      }

      current++;
    }
  }

  var short = Dijkstra();
  var shortest = short.shortestPath(graph, start)[end];

  print("Shortest solution is: $shortest.");

  var shortestLowest = lowest
      .map((l) => short.shortestPath(graph, l)[end])
      .reduce((value, element) => value < element ? value : element);

  print("Shortest solution from any lowest point is: $shortestLowest.");
}
