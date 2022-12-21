import 'dart:math';

import 'package:d16/d16.dart';
import 'package:dartx/dartx.dart';
import 'package:trotter/trotter.dart';

final sample = [
  "Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
  "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
  "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
  "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
  "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
  "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
  "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
  "Valve HH has flow rate=22; tunnel leads to valve GG",
  "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
  "Valve JJ has flow rate=21; tunnel leads to valve II",
];

var input = readInput().map((e) => e.split(" ")).map((e) => Valve(
    e[1],
    int.parse(e[4].removePrefix("rate=").removeSuffix(";")),
    e.sublist(9).map((e) => e.removeSuffix(",")).toList()));

class Valve {
  Valve(this.key, this.value, this.destinations);

  String key;
  int value;
  List<String> destinations;
}

Map<String, Map<String, int>> getPaths(Map<String, Valve> valves) {
  var shortestPaths = valves.values.associate(
      (e) => MapEntry(e.key, e.destinations.associateWith((v) => 1)));

  for (var from in shortestPaths.keys) {
    for (var to in shortestPaths.keys) {
      for (var middle in shortestPaths.keys) {
        shortestPaths[from]![to] = min(
            shortestPaths[from]?[to] ?? 9999999999,
            (shortestPaths[from]?[middle] ?? 9999999999) +
                (shortestPaths[middle]?[to] ?? 9999999999));
      }
    }
  }

  //Remove rooms that suck.
  shortestPaths =
      shortestPaths.filter((e) => valves[e.key]!.value > 0 || e.key == "AA");
  for (var key in shortestPaths.keys) {
    shortestPaths[key] =
        shortestPaths[key]!.filter((e) => valves[e.key]!.value > 0);
  }

  return shortestPaths;
}

int mostReleased(
    Map<String, Valve> valves,
    Map<String, Map<String, int>> paths,
    String current,
    Set<String> opened,
    int round,
    int maxRounds,
    int totalReleased) {
  return paths[current]!
          .filter((e) => !opened.contains(e.key))
          .filter((e) => round + e.value + 1 < maxRounds)
          .map((key, value) {
            var newOpened = Set<String>.from(opened);
            newOpened.add(key);

            return MapEntry(
                key,
                mostReleased(
                    valves,
                    paths,
                    key,
                    newOpened,
                    round + value + 1,
                    maxRounds,
                    totalReleased +
                        ((maxRounds - round - value - 1) *
                            valves[key]!.value)));
          })
          .toList()
          .map((e) => e.second)
          .max() ??
      totalReleased;
}

void main(List<String> arguments) {
  Map<String, Valve> valves = {for (var e in input) e.key: e};

  var paths = getPaths(valves);

  var released = mostReleased(valves, paths, "AA", {}, 0, 30, 0);

  print("Max released $released");

  var noAA = paths.keys.filter((e) => e != "AA").toList();
  var halves = Combinations((noAA.length / 2).floor(), noAA)();

  released = halves.map((e) {
        return mostReleased(valves, paths, "AA", Set.from(e), 0, 26, 0) +
            mostReleased(
                valves, paths, "AA", Set.from(paths.keys.except(e)), 0, 26, 0);
      }).max() ??
      0;

  print("Max released avec Éléphant $released");
}
