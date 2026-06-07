// Simple linked collection implementations used to replace List/Set/Map usages.
// Not production-optimized — minimal API to satisfy project needs.
import 'dart:collection';

class LinkedList<T> extends IterableBase<T> {
  _Node<T>? _head;
  _Node<T>? _tail;
  int _length = 0;

  LinkedList();

  LinkedList.from(Iterable<T> items) {
    addAll(items);
  }

  void add(T value) {
    final node = _Node(value);
    if (_head == null) {
      _head = _tail = node;
    } else {
      _tail!._next = node;
      _tail = node;
    }
    _length++;
  }

  void addAll(Iterable<T> items) {
    for (final it in items) {
      add(it);
    }
  }

  @override
  bool get isNotEmpty => _length > 0;
  @override
  bool get isEmpty => _length == 0;
  @override
  int get length => _length;

  T operator [](int index) {
    if (index < 0 || index >= _length) throw RangeError.index(index, this);
    var node = _head;
    for (var i = 0; i < index; i++) node = node!._next;
    return node!.value;
  }

  T removeAt(int index) {
    if (_head == null) throw RangeError.index(index, this);
    if (index == 0) return _removeFirst();
    var prev = _head;
    for (var i = 0; i < index - 1; i++) prev = prev!._next;
    final target = prev!._next!;
    prev._next = target._next;
    if (target == _tail) _tail = prev;
    _length--;
    return target.value;
  }

  T _removeFirst() {
    if (_head == null) throw StateError('No elements');
    final val = _head!.value;
    _head = _head!._next;
    if (_head == null) _tail = null;
    _length--;
    return val;
  }

  void clear() {
    _head = _tail = null;
    _length = 0;
  }

  @override
  List<T> toList({bool growable = true}) {
    final out = <T>[];
    for (final v in this) out.add(v);
    if (!growable) return List.unmodifiable(out);
    return out;
  }

  void sort([int Function(T a, T b)? compare]) {
    final l = toList();
    l.sort(compare);
    clear();
    addAll(l);
  }

  @override
  Iterator<T> get iterator => _LinkedListIterator(_head);
}

class LinkedEntry<K, V> {
  final K key;
  final V value;
  LinkedEntry(this.key, this.value);
}

class _Node<T> {
  T value;
  _Node<T>? _next;
  _Node(this.value);
}

class _LinkedListIterator<T> implements Iterator<T> {
  _Node<T>? _current;
  _Node<T>? _next;
  _LinkedListIterator(_Node<T>? head) : _next = head;

  @override
  T get current => _current!.value;

  @override
  bool moveNext() {
    if (_next == null) return false;
    _current = _next;
    _next = _next!._next;
    return true;
  }
}

class LinkedSet<T> {
  final LinkedList<T> _list = LinkedList<T>();

  void add(T value) {
    if (!contains(value)) _list.add(value);
  }

  bool contains(T value) {
    for (final v in _list) if (v == value) return true;
    return false;
  }

  List<T> toList() => _list.toList();
}

class LinkedMap<K, V> {
  final LinkedList<LinkedEntry<K, V>> _entries = LinkedList();

  LinkedMap();

  LinkedMap.fromMap(dynamic m) {
    if (m is Map) {
      for (final e in m.entries) {
        this[e.key as K] = e.value as V;
      }
    }
  }

  V? operator [](K key) {
    for (final e in _entries) {
      final me = e;
      if (me.key == key) return me.value;
    }
    return null;
  }

  void operator []=(K key, V value) {
    for (final e in _entries) {
      final me = e;
      if (me.key == key) {
        final newEntry = LinkedEntry(key, value);
        // replace by rebuilding list (simple, not optimized)
        final list = _entries.toList();
        for (var i = 0; i < list.length; i++) {
          if (list[i].key == key) {
            list[i] = newEntry as dynamic;
            break;
          }
        }
        _entries.clear();
        _entries.addAll(list.cast<LinkedEntry<K, V>>());
        return;
      }
    }
    _entries.add(LinkedEntry(key, value));
  }

  V putIfAbsent(K key, V Function() ifAbsent) {
    final existing = this[key];
    if (existing != null) return existing;
    final val = ifAbsent();
    this[key] = val;
    return val;
  }

  bool containsKey(K key) {
    for (final e in _entries) if ((e).key == key) return true;
    return false;
  }

  Iterable<LinkedEntry<K, V>> get entries => _entries;

  Map<K, V> toMap() {
    final m = <K, V>{};
    for (final e in _entries) {
      final me = e;
      m[me.key] = me.value;
    }
    return m;
  }

  void forEach(void Function(K, V) f) {
    for (final e in _entries) {
      final me = e;
      f(me.key, me.value);
    }
  }

  Map<K2, V2> map<K2, V2>(LinkedEntry<K2, V2> Function(K key, V value) transform) {
    final out = <K2, V2>{};
    for (final e in _entries) {
      final me = e;
      final newEntry = transform(me.key, me.value);
      out[newEntry.key] = newEntry.value;
    }
    return out;
  }

  void clear() {
    _entries.clear();
  }
}
