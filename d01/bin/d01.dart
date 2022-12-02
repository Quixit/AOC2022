import 'package:d01/d01.dart';
import 'package:collection/collection.dart';

final sample = [
1000,
2000,
3000,
-1,
4000,
-1,
5000,
6000,
-1,
7000,
8000,
9000,
-1,
10000,
-1
];

final input = readInput().map((e) {
  if (e.isEmpty) {
    return -1;
  } else {
    return int.parse(e);
  }
}).toList();

void main(List<String> arguments) {
  final calories = PriorityQueue<int>();

  var running = 0;
  for(var i =0; i < input.length; i++) {
    if (input[i] == -1) {
      calories.add(running);
      running = 0;
    }
    else {
      running += input[i];      
    }
  }

  print('Top calories: ${calories.toList()[calories.length-1]}!');
  print('Top 3 calories: ${calories.toList()[calories.length-1] + calories.toList()[calories.length-2] + calories.toList()[calories.length-3]}!');
}
