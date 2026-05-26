import 'package:flutter/material.dart';

import 'autocomplete_screen.dart';
import 'keyword_search_screen.dart';
import 'spell_checker_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trie Applications',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SpellCheckerScreen(),
                  ),
                );
              },
              child: const Text(
                'Spell Checker',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AutocompleteScreen(),
                  ),
                );
              },
              child: const Text(
                'Autocomplete',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const KeywordSearchScreen(),
                  ),
                );
              },
              child: const Text(
                'Keyword Search',
              ),
            ),
          ],
        ),
      ),
    );
  }
}