import 'package:flutter/material.dart';

import '../models/trie.dart';

class AutocompleteScreen
    extends StatefulWidget {
  const AutocompleteScreen({
    super.key,
  });

  @override
  State<AutocompleteScreen>
      createState() =>
          _AutocompleteScreenState();
}

class _AutocompleteScreenState
    extends State<AutocompleteScreen> {
  final Trie trie = Trie();

  final TextEditingController
      inputController =
      TextEditingController();

  final TextEditingController
      prefixController =
      TextEditingController();

  List<MapEntry<String, int>>
      suggestions = [];

  void addWords() {
    String text =
        inputController.text.toLowerCase();

    text = text.replaceAll(
      RegExp(r'[^a-zA-Z\s]'),
      ' ',
    );

    List<String> words = text.split(
      RegExp(r'\s+'),
    );

    for (String word in words) {
      if (word.isNotEmpty) {
        trie.insert(word);
      }
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Đã thêm dữ liệu',
        ),
      ),
    );
  }

  void searchPrefix() {
    suggestions = trie.autocomplete(
      prefixController.text
          .toLowerCase(),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Autocomplete',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:
                  inputController,
              maxLines: 4,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
                hintText:
                    'Nhập dữ liệu...',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: addWords,
              child: const Text(
                'Xây dựng Trie',
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  prefixController,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
                hintText:
                    'Nhập prefix...',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: searchPrefix,
              child: const Text(
                'Gợi ý',
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount:
                    suggestions.length,
                itemBuilder:
                    (context, index) {
                  return ListTile(
                    title: Text(
                      suggestions[index]
                          .key,
                    ),
                    trailing: Text(
                      'Freq: ${suggestions[index].value}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}