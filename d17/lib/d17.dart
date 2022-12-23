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

class Vector {
  Vector(this.x, this.y);

  int x;
  int y;

  List<Vector> lineTo(Vector destination) {
    List<Vector> result = [];

    var xIterator = x;
    var yIterator = y;

    while (x > destination.x
        ? xIterator >= destination.x
        : xIterator <= destination.x) {
      result.add(Vector(xIterator, yIterator));

      if (y > destination.y) {
        yIterator--;
      } else {
        yIterator++;
      }

      if (x > destination.x) {
        xIterator--;
      } else {
        xIterator++;
      }
    }

    return result;
  }
}

class Dijkstra {
  minDistance(List<int> dist, List<bool> sptSet, int V) {
    var min = double.maxFinite.floor();
    var minIndex = -1;

    for (var v = 0; v < V; v++) {
      if (sptSet[v] == false && dist[v] <= min) {
        min = dist[v];
        minIndex = v;
      }
    }
    return minIndex;
  }

  List<int> shortestPath(List<List<int>> graph, int src) {
    var vertices = graph.length;
    var dist = List.filled(vertices, double.maxFinite.floor());
    var sptSet = List.filled(vertices, false);

    dist[src] = 0;

    for (var count = 0; count < vertices - 1; count++) {
      var u = minDistance(dist, sptSet, vertices);

      sptSet[u] = true;

      for (var vertex = 0; vertex < vertices; vertex++) {
        if (!sptSet[vertex] &&
            graph[u][vertex] != 0 &&
            dist[u] != double.maxFinite.floor() &&
            dist[u] + graph[u][vertex] < dist[vertex]) {
          dist[vertex] = dist[u] + graph[u][vertex];
        }
      }
    }

    return dist;
  }
}

int getManhattan(Vector one, Vector two) {
  return (one.x - two.x).abs() + (one.y - two.y).abs();
}

class LoopQueue<T> {
  LoopQueue(this.data);

  List<T> data;
  int index = 0;

  T get next {
    var result = data[index];

    index++;

    if (index >= data.length) index = 0;

    return result;
  }
}
