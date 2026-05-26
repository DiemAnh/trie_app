import 'package:flutter/material.dart';

import '../models/trie.dart';
import '../services/spell_service.dart';

class SpellCheckerScreen
    extends StatefulWidget {
  const SpellCheckerScreen({
    super.key,
  });

  @override
  State<SpellCheckerScreen>
      createState() =>
          _SpellCheckerScreenState();
}

class _SpellCheckerScreenState
    extends State<SpellCheckerScreen> {
  final TextEditingController controller =
      TextEditingController();

  Trie trie = Trie();

  List<String> invalidWords = [];

  void checkText() {
    invalidWords =
        SpellService.findInvalidWords(
      controller.text,
      trie,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Spell Checker',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 5,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
                hintText:
                    'Nhập văn bản...',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: checkText,
              child: const Text(
                'Kiểm tra',
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount:
                    invalidWords.length,
                itemBuilder:
                    (context, index) {
                  return ListTile(
                    title: Text(
                      invalidWords[index],
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