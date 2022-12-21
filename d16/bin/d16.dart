import 'dart:collection';

import 'package:d16/d16.dart';
import 'package:dartx/dartx.dart';

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

var input = sample.map((e) => e.split(" ")).map((e) => Valve(
    e[1],
    int.parse(e[4].removePrefix("rate=").removeSuffix(";")),
    e.sublist(9).map((e) => e.removeSuffix(",")).toList()));

//readInput();

var max = 29;

class Valve {
  Valve(this.key, this.value, this.destinations);

  String key;
  int value;
  List<Valve> destinations;
}

class Result {
  Result(this.current, this.activated, this.timer);

  Valve current;
  List<Valve> activated;
  int timer;

  Result next(Valve node) {
    return Result(node, List.from(activated), timer + 1);
  }

  int process(Map<String, Valve> valves) {
    if (current.value == 0 || activated.contains(current)) {
      // don't activate
    } else {
      activated.add(current);
      timer++;
    }

    if (timer == max) {
      results.add(this);
    }
    if (timer > max) {
    } else {
      var validDestinations = current.destinations;

      if (validDestinations.isNotEmpty) {
        for (var destination in validDestinations) {
          next(valves[destination]!).process(valves, results);
        }
      } else {
        results.add(this);
      }
    }
  }
}

void main(List<String> arguments) {
  Map<String, Valve> valves = {for (var e in input) e.key: e};

  var released = Result(valves["AA"]!, <Valve>[], 0).process(valves);

  print("The max pressure released is: $max");
}
