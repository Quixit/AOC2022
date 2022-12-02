import 'package:d02/d02.dart';
import 'package:collection/collection.dart';

final sample = [
  ["A", "Y"],
  ["B", "X"],
  ["C", "Z"],
];

final input = readInput().map((e) => [e.substring(0,1), e.substring(2,3) ]).toList();

int score(String opponent, String player) {
  var result = 0;

  switch(player)
  {
    case "X": //rock
      result += 1;

      switch(opponent)
      {
        case "A": //rock
          result += 3;
          break;
        case "B": //paper
          result += 0;
          break;
        case "C": //scissors
          result += 6;
          break;
      }
  
      break;
    case "Y": //paper
      result += 2;

      switch(opponent)
      {
        case "A": //rock
          result += 6;
          break;
        case "B": //paper
          result += 3;
          break;
        case "C": //scissors
          result += 0;
          break;
      }

      break;
    case "Z": //scissors
      result += 3;

      switch(opponent)
      {
        case "A": //rock
          result += 0;
          break;
        case "B": //paper
          result += 6;
          break;
        case "C": //scissors
          result += 3;
          break;
      }

      break;
  }

  return result;
}

int newScore(String opponent, String outcome) {
  var result = 0;

  switch(outcome)
  {
    case "X": //lose
      switch(opponent)
      {
        case "A": //rock
          result += 3;
          break;
        case "B": //paper
          result += 1;
          break;
        case "C": //scissors
          result += 2;
          break;
      }
  
      break;
    case "Y": //draw
      switch(opponent)
      {
        case "A": //rock
          result += 4;
          break;
        case "B": //paper
          result += 5;
          break;
        case "C": //scissors
          result += 6;
          break;
      }

      break;
    case "Z": //win
      switch(opponent)
      {
        case "A": //rock
          result += 8;
          break;
        case "B": //paper
          result += 9;
          break;
        case "C": //scissors
          result += 7;
          break;
      }

      break;
  }

  return result;
}

void main(List<String> arguments) {
  var total = 0;

  for (var element in input) {
    total += score(element[0],element[1]);
  }

  print('Original Predicted Score: $total!');

  total = 0;

  for (var element in input) {
    total += newScore(element[0],element[1]);
  }

  print('Revised Predicted Score: $total!');
}
