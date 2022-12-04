import 'package:d04/d04.dart';
import 'dart:collection';

final sample = processInput(
  [
    "2-4,6-8",
    "2-3,4-5",
    "5-7,7-9",
    "2-8,3-7",
    "6-6,4-6",
    "2-6,4-8",
  ]
);

final input = processInput(readInput());

Iterable<List<HashSet<int>>> processInput (List<String> input) {
  return input.map((e) => e.split(",")
    .map((e) => 
      getRangeSet(
        int.parse(e.split("-")[0]), 
        int.parse(e.split("-")[1])
      )
    ).toList()
  );
}

void main(List<String> arguments) {
  var full = 0;
  var partial = 0;
  
  for (var pair in input)
  {
    var one = pair[0];
    var two = pair[1];

    var intersection = one.intersection(two);

    if (intersection.length == one.length || intersection.length == two.length) {
      full++;
    }

    if (intersection.isNotEmpty) {
      partial++;
    }
  }

  print('Full Intersections: $full!');
  print('Partial Intersections: $partial!');
}
