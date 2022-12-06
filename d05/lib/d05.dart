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

HashSet<int> getRangeSet(int from, int to) {
  if (to < from) {
    int temp = to;
    to = from;
    from = temp;
  }

  var result = HashSet<int>();

  for (var i = from; i <= to; i++) {
    result.add(i);
  }

  return result;
}

class Stack<T> extends Iterable<T> {
  StackItem<T>? _head;

  void push(T item) {
    _head = StackItem(item, _head);
  }

  T pop() {
    var item = _head?.item;

    if (item == null) {
      throw RangeError("Stack contains no elements.");
    } else {
      _head = _head?.next;
      return item;
    }
  }

  @override
  Iterator<T> get iterator => StackIterator(_head);
}

class StackItem<T> {
  StackItem(this.item, this.next);

  T item;
  StackItem<T>? next;
}

class StackIterator<T> extends Iterator<T> {
  StackItem<T>? _head;
  T? _current;

  StackIterator(StackItem<T>? head) {
    _head = head;
  }

  @override
  T get current => _current!;

  @override
  bool moveNext() {
    _current = _head?.item;

    if (_current == null) {
      return false;
    } else {
      _head = _head?.next;

      return true;
    }
  }
}
