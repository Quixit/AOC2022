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

HashSet<int> getRangeSet(int from, int to)
{
  if  (to < from) {
      int temp = to;
      to = from;
      from = temp;
  }

  var result = HashSet<int>();

  for(var i = from; i<=to; i++)
  {
    result.add(i);
  }

  return result;
}
