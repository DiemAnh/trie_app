class TrieNode {
  Map<String, TrieNode> children = {};

  bool isEndOfWord = false;

  int frequency = 0;
}