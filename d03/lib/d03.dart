import 'dart:collection';
import 'dart:io';

List<String> readInput() {
  File file = File('input.txt');

  // sync
  List<String> lines = file.readAsLinesSync();

  return lines;
}

HashSet<String> getCharSet(String input) {
  var result = HashSet<String>();

  for (var i = 0; i < input.length; i++) {
    result.add(input[i]);
  }
  return result;
}
