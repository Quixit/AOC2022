import 'package:d15/d15.dart';
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

enum GridValue { beacon, sensor, cannotcontain }

var minSize = 0;
var maxSize = 4000000;

final input = readInput().map((e) {
  var split = e.split(" ");
  return DataEntry(
      Vector(int.parse(split[2].substring(2, split[2].length - 1)),
          int.parse(split[3].substring(2, split[3].length - 1))),
      Vector(int.parse(split[8].substring(2, split[8].length - 1)),
          int.parse(split[9].substring(2, split[9].length))));
});

class DataEntry {
  DataEntry(this.sensor, this.beacon) {
    manhattan = getManhattan(sensor, beacon);
    top = Vector(sensor.x, sensor.y - manhattan - 1);
    bottom = Vector(sensor.x, sensor.y + manhattan + 1);
    left = Vector(sensor.x - manhattan - 1, sensor.y);
    right = Vector(sensor.x + manhattan + 1, sensor.y);
  }

  late int manhattan;
  late Vector top;
  late Vector bottom;
  late Vector left;
  late Vector right;

  Vector sensor;
  Vector beacon;

  IntRange? findRange(int y) {
    var scanWidth = manhattan - (sensor.y - y).abs();
    var result = IntRange(sensor.x - scanWidth, sensor.x + scanWidth);

    if (result.first <= result.last) {
      return result;
    } else {
      return null;
    }
  }

  bool inRange(Vector vector) {
    return getManhattan(sensor, vector) <= manhattan;
  }
}

var countRow = 20; // 2000000;

List<IntRange> removeOverlaps(Iterable<IntRange> source) {
  List<IntRange> result = [];

  for (var item in source.sortedBy((e) => e.first)) {
    var lastRange =
        result.isEmpty ? IntRange(-10000000, -10000000) : result.last;

    if (item.first <= lastRange.last) {
      result[result.lastIndex] = IntRange(lastRange.first,
          lastRange.last > item.last ? lastRange.last : item.last);
    } else {
      result.add(item);
    }
  }

  return result;
}

void main(List<String> arguments) {
  var cantContain =
      removeOverlaps(input.mapNotNull((e) => e.findRange(countRow)))
          .sumBy((e) => e.last - e.first);

  print("$cantContain can't contain a beacon.");

  Vector location = Vector(0, 0);

  for (var item in input) {
    var points = item.top.lineTo(item.right);
    points.addAll(item.right.lineTo(item.bottom));
    points.addAll(item.bottom.lineTo(item.left));
    points.addAll(item.left.lineTo(item.top));

    var result = points
        .where((e) =>
            e.x <= maxSize &&
            e.x >= minSize &&
            e.y <= maxSize &&
            e.y >= minSize)
        .where((item) => input.none((e) => e.inRange(item)))
        .firstOrNull;

    if (result != null) {
      location = result;
      break;
    }
  }

  print("The frequency is ${4000000 * location.x + location.y}");
}
