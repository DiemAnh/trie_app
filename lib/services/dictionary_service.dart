import 'dart:io';
import '../models/trie.dart';

class DictionaryService {
  static Future<void> loadDictionary(
    String path,
    Trie trie,
  ) async {
    File file = File(path);

    List<String> lines = await file.readAsLines();

    for (String word in lines) {
      word = word.trim().toLowerCase();

      if (word.isNotEmpty) {
        trie.insert(word);
      }
    }
  }
}