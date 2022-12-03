import 'package:d03/d03.dart';

final sample = [
  "vJrwpWtwJgWrhcsFMMfFFhFp",
  "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
  "PmmdzqPrVvPwwTWBwg",
  "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
  "ttgJtRGJQctTZtZT",
  "CrZsJsPPZsGzwwsLwLmpwMDw",
];

final input = readInput();

int score(String value) {
  var code = value.codeUnitAt(0);

  if (code > 96) {
    //lower case letters start at 97
    return code - 96;
  } else {
    //upper case letters start at 64
    return code - 64 + 26; //UCase scores start at 26
  }
}

void main(List<String> arguments) {
  var total = 0;

  for (var element in input) {
    var half = (element.length / 2).floor();
    var first = element.substring(0, half);
    var second = element.substring(half);

    if (first.length != second.length) throw "Different lengths!";

    var set = getCharSet(first);

    for (var i = 0; i < second.length; i++) {
      if (set.contains(second[i])) {
        total += score(second[i]);
        break;
      }
    }
  }

  print('Missorted Score: $total!');

  total = 0;

  for (var i = 0; i < input.length; i += 3) {
    var first = getCharSet(input[i]);
    var second = getCharSet(input[i + 1]);
    var third = getCharSet(input[i + 2]);

    var intersection = first.intersection(second).intersection(third);

    total += score(intersection.single);
  }

  print('Badge Score: $total!');
}
