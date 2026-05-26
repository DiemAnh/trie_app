import '../models/trie.dart';

class SpellService {
  static List<String> findInvalidWords(
    String text,
    Trie trie,
  ) {
    text = text.toLowerCase();

    text = text.replaceAll(
      RegExp(r'[^a-zA-Z\s]'),
      ' ',
    );

    List<String> words = text.split(
      RegExp(r'\s+'),
    );

    Set<String> invalidWords = {};

    for (String word in words) {
      if (word.isNotEmpty &&
          !trie.search(word)) {
        invalidWords.add(word);
      }
    }

    return invalidWords.toList();
  }
}