import 'dart:io';

List<String> readInput() {
  File file = File('input.txt');

  // sync
  List<String> lines = file.readAsLinesSync();

  return lines;
}