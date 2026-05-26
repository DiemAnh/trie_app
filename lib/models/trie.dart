import 'dart:convert';
import 'trie_node.dart';

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

  List<MapEntry<String, int>> autocomplete(String prefix) {
    TrieNode? current = root;

    for (int i = 0; i < prefix.length; i++) {
      String ch = prefix[i];

      if (!current!.children.containsKey(ch)) {
        return [];
      }

      current = current.children[ch];
    }

    List<MapEntry<String, int>> result = [];

    _dfs(current!, prefix, result);

    result.sort((a, b) => b.value.compareTo(a.value));

    return result;
  }

  void _dfs(
    TrieNode node,
    String currentWord,
    List<MapEntry<String, int>> result,
  ) {
    if (node.isEndOfWord) {
      result.add(MapEntry(currentWord, node.frequency));
    }

    for (var entry in node.children.entries) {
      _dfs(entry.value, currentWord + entry.key, result);
    }
  }

  List<String> bfsAutocomplete(String prefix) {
    TrieNode? current = root;

    for (int i = 0; i < prefix.length; i++) {
      String ch = prefix[i];

      if (!current!.children.containsKey(ch)) {
        return [];
      }

      current = current.children[ch];
    }

    List<String> result = [];

    List<MapEntry<TrieNode, String>> queue = [
      MapEntry(current!, prefix)
    ];

    while (queue.isNotEmpty) {
      var item = queue.removeAt(0);

      TrieNode node = item.key;

      String word = item.value;

      if (node.isEndOfWord) {
        result.add(word);
      }

      for (var child in node.children.entries) {
        queue.add(
          MapEntry(
            child.value,
            word + child.key,
          ),
        );
      }
    }

    return result;
  }

  Map<String, dynamic> toJsonNode(TrieNode node) {
    return {
      'isEndOfWord': node.isEndOfWord,
      'frequency': node.frequency,
      'children': node.children.map(
        (key, value) => MapEntry(
          key,
          toJsonNode(value),
        ),
      ),
    };
  }

  TrieNode fromJsonNode(Map<String, dynamic> json) {
    TrieNode node = TrieNode();

    node.isEndOfWord = json['isEndOfWord'];

    node.frequency = json['frequency'];

    Map<String, dynamic> children = json['children'];

    children.forEach((key, value) {
      node.children[key] = fromJsonNode(value);
    });

    return node;
  }

  String exportTrie() {
    return jsonEncode(toJsonNode(root));
  }

  void importTrie(String data) {
    root = fromJsonNode(jsonDecode(data));
  }
}