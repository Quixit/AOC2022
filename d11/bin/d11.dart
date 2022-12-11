import 'package:d11/d11.dart';
import 'dart:collection';

final sample = readMonkey([
  "Monkey 0:",
  "  Starting items: 79, 98",
  "  Operation: new = old * 19",
  "  Test: divisible by 23",
  "    If true: throw to monkey 2",
  "    If false: throw to monkey 3",
  "",
  "Monkey 1:",
  "  Starting items: 54, 65, 75, 74",
  "  Operation: new = old + 6",
  "  Test: divisible by 19",
  "    If true: throw to monkey 2",
  "    If false: throw to monkey 0",
  "",
  "Monkey 2:",
  "  Starting items: 79, 60, 97",
  "  Operation: new = old * old",
  "  Test: divisible by 13",
  "    If true: throw to monkey 1",
  "    If false: throw to monkey 3",
  "",
  "Monkey 3:",
  "  Starting items: 74",
  "  Operation: new = old + 3",
  "  Test: divisible by 17",
  "    If true: throw to monkey 0",
  "    If false: throw to monkey 1",
]);

final input = readMonkey(readInput());

class Monkey {
  int inspections = 0;
  Queue<int> items = Queue();

  String operator = "";
  int operationValue = 0;

  int test = 0;
  int trueDestination = 0;
  int falseDestination = 0;
}

List<Monkey> readMonkey(List<String> input) {
  var monkey = Monkey();
  List<Monkey> result = [];

  for (var i = 1; i < input.length; i++) {
    var line = input[i].trim().split(" ");

    switch (line[0]) {
      case "Monkey":
        result.add(monkey);
        monkey = Monkey();
        break;
      case "Starting":
        for (var x = 2; x < line.length; x++) {
          monkey.items.add(int.parse(line[x].replaceAll(",", "")));
        }
        break;
      case "Operation:":
        monkey.operator = line[4];
        monkey.operationValue = line[5] == "old" ? -42 : int.parse(line[5]);
        break;
      case "Test:":
        monkey.test = int.parse(line[3]);
        break;
      case "If":
        if (line[1] == "true:") {
          monkey.trueDestination = int.parse(line[5]);
        } else {
          monkey.falseDestination = int.parse(line[5]);
        }
        break;
    }
  }

  result.add(monkey);

  return result;
}

void process(List<Monkey> monkeys, int rounds, bool divideWorry) {
  var testProduct =
      monkeys.map((e) => e.test).reduce((value, element) => value * element);

  for (var x = 0; x < rounds; x++) {
    for (var y = 0; y < monkeys.length; y++) {
      var monkey = monkeys[y];

      while (monkey.items.isNotEmpty) {
        var item = monkey.items.first;
        monkey.items.removeFirst();

        monkey.inspections++;

        if (monkey.operator == "+") {
          if (monkey.operationValue == -42) {
            item = item + item;
          } else {
            item = item + monkey.operationValue;
          }
        } else if (monkey.operator == "*") {
          if (monkey.operationValue == -42) {
            item = item * item;
          } else {
            item = item * monkey.operationValue;
          }
        }

        if (divideWorry) {
          item = (item / 3).floor();
        }

        monkeys[item % monkey.test == 0
                ? monkey.trueDestination
                : monkey.falseDestination]
            .items
            .add(item % testProduct);
      }
    }
  }
}

void main(List<String> arguments) {
  process(input, 20, true);

  var inspections = input.map((m) => m.inspections).toList();

  inspections.sort();

  print(
      "Monkey Business: ${inspections[inspections.length - 1] * inspections[inspections.length - 2]}");

  var second = readMonkey(readInput());

  process(second, 10000, false);

  inspections = second.map((m) => m.inspections).toList();

  inspections.sort();

  print(
      "Extreme Monkey Business: ${inspections[inspections.length - 1] * inspections[inspections.length - 2]}");
}
