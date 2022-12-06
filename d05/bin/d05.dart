import 'package:d05/d05.dart';
import 'dart:collection';

final sample = processInput([
  "    [D]    ",
  "[N] [C]    ",
  "[Z] [M] [P]",
  " 1   2   3 ",
  "",
  "move 1 from 2 to 1",
  "move 3 from 1 to 3",
  "move 2 from 2 to 1",
  "move 1 from 1 to 2",
]);

final input = processInput(readInput());
final inputMulti = processInput(readInput());

class Input {
  Input(this.stacks, this.moves);

  List<Stack<String>> stacks;
  List<Move> moves;

  void process(bool multi) {
    for (var move in moves) {
      if (multi) {
        move.processMulti(stacks);
      } else {
        move.process(stacks);
      }
    }
  }

  String get tops => stacks.map((e) => e.first).join("");
}

class Move {
  Move(this.quantity, this.from, this.to);

  int quantity;
  int from;
  int to;

  void process(List<Stack<String>> stacks) {
    for (var i = 0; i < quantity; i++) {
      var item = stacks[from - 1].pop();
      stacks[to - 1].push(item);
    }
  }

  void processMulti(List<Stack<String>> stacks) {
    var temp = Stack<String>(); //Yes I really was that lazy.

    for (var i = 0; i < quantity; i++) {
      var item = stacks[from - 1].pop();
      temp.push(item);
    }

    while (temp.isNotEmpty) {
      stacks[to - 1].push(temp.pop());
    }
  }
}

Input processInput(List<String> input) {
  List<Stack<String>> stacks = [];
  List<Move> moves = [];

  for (var i = 0; i < input.length; i++) {
    if (input[i].startsWith(" 1   2")) {
      for (var x = 0; x < input[i].length; x += 4) {
        stacks.add(Stack());
      }

      for (var x = i - 1; x >= 0; x--) {
        for (var y = 0; y < stacks.length; y++) {
          var start = (y * 4) + 1;
          var item = input[x].substring(start, start + 1);

          if (item != " ") {
            stacks[y].push(item);
          }
        }
      }
    } else if (input[i].startsWith("move")) {
      var split = input[i].split(" ");

      moves.add(
          Move(int.parse(split[1]), int.parse(split[3]), int.parse(split[5])));
    }
  }

  return Input(stacks, moves);
}

void main(List<String> arguments) {
  input.process(false);
  inputMulti.process(true);

  print('Single Crates: ${input.tops}!');
  print('Multi Crate: ${inputMulti.tops}!');
}
