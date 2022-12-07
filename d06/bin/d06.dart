import 'package:d06/d06.dart';
import 'dart:collection';

final sample = "mjqjpqmgbljsphdztnvjfqwrcgsmlb";

final input = readInput().first;

findUnique(int len) {
  for (var i = (len - 1); i < input.length; i++) {
    var buffer = input.substring(i - (len - 1), i + 1);

    var set = HashSet<String>();

    for (var x = 0; x < buffer.length; x++) {
      set.add(buffer[x]);
    }

    if (set.length == len) {
      print('$len unique at: ${i + 1}!');
      break;
    }
  }
}

void main(List<String> arguments) {
  findUnique(4);
  findUnique(14);
}
