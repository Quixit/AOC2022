import 'dart:ffi';

import 'package:d13/d13.dart';
import 'dart:collection';

final sample = [
  "[1,1,3,1,1]",
  "[1,1,5,1,1]",
  "",
  "[[1],[2,3,4]]",
  "[[1],4]",
  "",
  "[9]",
  "[[8,7,6]]",
  "",
  "[[4,4],4,4]",
  "[[4,4],4,4,4]",
  "",
  "[7,7,7,7]",
  "[7,7,7]",
  "",
  "[]",
  "[3]",
  "",
  "[[[]]]",
  "[[]]",
  "",
  "[1,[2,[3,[4,[5,6,7]]]],8,9]",
  "[1,[2,[3,[4,[5,6,0]]]],8,9]",
];

final input =
    readInput().where((e) => e.isNotEmpty).map((e) => ArrayNode(e)).toList();

abstract class ValueNode {
  bool? shouldComeBefore(ValueNode node);
}

class IntegerNode extends ValueNode {
  IntegerNode(String input) {
    value = int.parse(input);
  }

  int value = 0;

  @override
  bool? shouldComeBefore(ValueNode node) {
    if (node is IntegerNode) {
      if (value < node.value) {
        return true;
      } else if (value > node.value) {
        return false;
      } else {
        return null;
      }
    } else if (node is ArrayNode) {
      return ArrayNode("[$value]").shouldComeBefore(node);
    }

    throw Exception("Invalid node type");
  }
}

class ArrayNode extends ValueNode {
  ArrayNode(String input) {
    list = [];

    if (input[0] != "[" || input[input.length - 1] != "]") {
      throw Exception("invalid array.");
    }

    var i = 1;

    while (i < input.length - 1) {
      if (input[i] == "[") {
        var start = i;
        while (input[i] != "]") {
          i++;
        }

        i++; //skip ,

        list.add(ArrayNode(input.substring(start, i)));
      } else {
        var buffer = "";

        while (input[i] != "," && input[i] != "]") {
          buffer += input[i];
          i++;
        }

        if (buffer.isNotEmpty) {
          list.add(IntegerNode(buffer));
        }
      }

      i++;
    }
  }

  List<ValueNode> list = [];

  @override
  bool? shouldComeBefore(ValueNode node) {
    if (node is IntegerNode) {
      return shouldComeBefore(ArrayNode("[${node.value}]"));
    } else if (node is ArrayNode) {
      var i = 0;

      while (true) {
        if (list.length < i + 1 && node.list.length < i + 1) {
          //both run out.

          return null;
        }

        if (list.length < i + 1) {
          // this run out
          return true;
        }
        if (node.list.length < i + 1) {
          // this run out
          return false;
        }

        var result = list[i].shouldComeBefore(node.list[i]);

        if (result != null) {
          return result;
        }

        i++;
      }
    }

    throw Exception("Invalid node type");
  }
}

void main(List<String> arguments) {
  var sum = 0;

  for (var i = 0; i < input.length; i += 2) {
    if (input[i].shouldComeBefore(input[i + 1]) == true) {
      sum += ((i / 2) + 1).floor();
    }
  }

  print("Sum of ordered pairs $sum");

  var dividerOne = ArrayNode("[[2]]");
  var dividerTwo = ArrayNode("[[6]]");

  input.add(dividerOne);
  input.add(dividerTwo);

  input.sort((a, b) => a.shouldComeBefore(b) == true ? -1 : 1);

  var decodeKey =
      (input.indexOf(dividerOne) + 1) * (input.indexOf(dividerTwo) + 1);

  print("Decoder Key $decodeKey");
}
