import '../models/trie.dart';
import '../models/linked_collections.dart';

class SpellService {
  static LinkedList<String> findInvalidWords(
    String text,
    Trie trie,
  ) {
    text = text.toLowerCase();

    text = text.replaceAll(
      RegExp(r'[^a-zA-Z\s]'),
      ' ',
    );

    final LinkedList<String> words = LinkedList.from(
      text.split(
        RegExp(r'\s+'),
      ),
    );

    final LinkedSet<String> invalidWords = LinkedSet();

    for (String word in words) {
      if (word.isNotEmpty &&
          !trie.search(word)) {
        invalidWords.add(word);
      }
    }

    return LinkedList.from(invalidWords.toList());
  }
}