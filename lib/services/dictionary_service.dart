import 'dart:io';
import '../models/trie.dart';
import '../models/linked_collections.dart';

class DictionaryService {
  static Future<void> loadDictionary(
    String path,
    Trie trie,
  ) async {
    File file = File(path);

    final LinkedList<String> lines = LinkedList.from(await file.readAsLines());

    for (String word in lines) {
      word = word.trim().toLowerCase();

      if (word.isNotEmpty) {
        trie.insert(word);
      }
    }
  }
}