import 'dart:convert';
import 'trie_node.dart';
import 'linked_collections.dart';

class Trie {
  TrieNode root = TrieNode();

  void insert(String word) {
    TrieNode current = root;

    for (int i = 0; i < word.length; i++) {
      String ch = word[i];

      current.children.putIfAbsent(ch, () => TrieNode());

      current = current.children[ch]!;
    }

    current.isEndOfWord = true;

    current.frequency++;
  }

  bool search(String word) {
    TrieNode? current = root;

    for (int i = 0; i < word.length; i++) {
      String ch = word[i];

      if (!current!.children.containsKey(ch)) {
        return false;
      }

      current = current.children[ch];
    }

    return current != null && current.isEndOfWord;
  }

  LinkedList<LinkedEntry<String, int>> autocomplete(String prefix) {
    TrieNode? current = root;

    for (int i = 0; i < prefix.length; i++) {
      String ch = prefix[i];

      if (!current!.children.containsKey(ch)) {
        return LinkedList<LinkedEntry<String, int>>();
      }

      current = current.children[ch];
    }

    final LinkedList<LinkedEntry<String, int>> result = LinkedList();

    _dfs(current!, prefix, result);

    result.sort((a, b) => b.value.compareTo(a.value));

    return result;
  }

  void _dfs(
    TrieNode node,
    String currentWord,
    LinkedList<LinkedEntry<String, int>> result,
  ) {
    if (node.isEndOfWord) {
      result.add(LinkedEntry(currentWord, node.frequency));
    }

    for (var entry in node.children.entries) {
      _dfs(entry.value, currentWord + entry.key, result);
    }
  }

  LinkedList<String> bfsAutocomplete(String prefix) {
    TrieNode? current = root;

    for (int i = 0; i < prefix.length; i++) {
      String ch = prefix[i];

      if (!current!.children.containsKey(ch)) {
        return LinkedList<String>();
      }

      current = current.children[ch];
    }

    final LinkedList<String> result = LinkedList();

    final LinkedList<LinkedEntry<TrieNode, String>> queue = LinkedList.from([
      LinkedEntry(current!, prefix)
    ]);

    while (queue.isNotEmpty) {
      var item = queue.removeAt(0);

      TrieNode node = item.key;

      String word = item.value;

      if (node.isEndOfWord) {
        result.add(word);
      }

      for (var child in node.children.entries) {
        queue.add(
          LinkedEntry(
            child.value,
            word + child.key,
          ),
        );
      }
    }

    return result;
  }

  LinkedMap<String, dynamic> toJsonNode(TrieNode node) {
    final LinkedMap<String, dynamic> m = LinkedMap();
    m['isEndOfWord'] = node.isEndOfWord;
    m['frequency'] = node.frequency;

    final LinkedMap<String, dynamic> children = LinkedMap();
    for (final e in node.children.entries) {
      final me = e;
      children[me.key] = toJsonNode(me.value).toMap();
    }
    m['children'] = children.toMap();

    return m;
  }

  TrieNode fromJsonNode(LinkedMap<String, dynamic> json) {
    TrieNode node = TrieNode();

    node.isEndOfWord = json['isEndOfWord'];

    node.frequency = json['frequency'];

    final rawChildren = json['children'];
    final LinkedMap<String, dynamic> children = rawChildren is LinkedMap
      ? (rawChildren as LinkedMap<String, dynamic>)
      : LinkedMap<String, dynamic>.fromMap(rawChildren);

    for (final LinkedEntry<String, dynamic> me in children.entries) {
      node.children[me.key] = fromJsonNode(LinkedMap<String, dynamic>.fromMap(me.value));
    }

    return node;
  }

  String exportTrie() {
    return jsonEncode(toJsonNode(root).toMap());
  }

  void importTrie(String data) {
    final decoded = jsonDecode(data);
    root = fromJsonNode(LinkedMap.fromMap(decoded));
  }
}