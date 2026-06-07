import 'linked_collections.dart';

class TrieNode {
  LinkedMap<String, TrieNode> children = LinkedMap();

  bool isEndOfWord = false;

  int frequency = 0;
}