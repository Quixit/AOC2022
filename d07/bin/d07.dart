import 'dart:developer';

import 'package:d07/d07.dart';
import 'dart:collection';

final sample = [
  "\$ cd /",
  "\$ ls",
  "dir a",
  "14848514 b.txt",
  "8504156 c.dat",
  "dir d",
  "\$ cd a",
  "\$ ls",
  "dir e",
  "29116 f",
  "2557 g",
  "62596 h.lst",
  "\$ cd e",
  "\$ ls",
  "584 i",
  "\$ cd ..",
  "\$ cd ..",
  "\$ cd d",
  "\$ ls",
  "4060174 j",
  "8033020 d.log",
  "5626152 d.ext",
  "7214296 k"
];

final input = readInput();

class FileNode {
  FileNode(this.name, this.size, this.parent);

  int? size; //null = directory
  String name;
  List<FileNode> children = [];
  FileNode? parent;

  int get total => size == null
      ? children.map((e) => e.total).reduce((value, element) => value + element)
      : (size ?? 0);

  int getAtMost(int max) {
    var result = 0;

    if (total <= max) {
      result += total;
    }

    //Subdirectories
    for (var item in children.where((e) => e.size == null)) {
      result += item.getAtMost(max);
    }

    return result;
  }

  int getFirstAtLeast(int min) {
    var result = 1073741824; //should be bit enough

    //Subdirectories
    for (var item in children.where((e) => e.size == null)) {
      var childTotal = item.getFirstAtLeast(min);

      if (childTotal < result) result = childTotal;
    }

    if (total >= min && result > total) {
      return total;
    } else {
      return result;
    }
  }
}

void main(List<String> arguments) {
  FileNode root = FileNode("/", null, null);
  FileNode node = root;

  //Build tree.
  var listing = false;
  for (var line in input) {
    if (line.startsWith("\$")) {
      listing = false;
      var split = line.split(" ");
      var command = split[1];

      if (command == "cd") {
        var dir = split[2];

        if (dir == "/") {
          node = root;
        } else if (dir == "..") {
          node = node.parent!;
        } else {
          node = node.children.firstWhere((e) => e.name == dir);
        }
      } else if (command == "ls") {
        listing = true;
      }
    } else if (listing) {
      var split = line.split(" ");
      var size = split[0];
      var name = split[1];

      if (size == "dir") {
        node.children.add(FileNode(name, null, node));
      } else {
        node.children.add(FileNode(name, int.parse(size), node));
      }
    }
  }

  var result = root.getAtMost(100000);

  log("Total Under 100000: $result");

  //needed - (total - used).
  var space = 30000000 - (70000000 - root.total);

  result = root.getFirstAtLeast(space);

  log("Smallest At Least $space: $result");
}
