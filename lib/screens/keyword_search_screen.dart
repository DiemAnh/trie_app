import 'package:flutter/material.dart';

class KeywordSearchScreen
    extends StatefulWidget {
  const KeywordSearchScreen({
    super.key,
  });

  @override
  State<KeywordSearchScreen>
      createState() =>
          _KeywordSearchScreenState();
}

class _KeywordSearchScreenState
    extends State<KeywordSearchScreen> {
  final TextEditingController
      textController =
      TextEditingController();

  final TextEditingController
      keywordController =
      TextEditingController();

  bool found = false;

  void searchKeyword() {
    found = textController.text
        .toLowerCase()
        .contains(
          keywordController.text
              .toLowerCase(),
        );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keyword Search',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:
                  textController,
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

            TextField(
              controller:
                  keywordController,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
                hintText:
                    'Nhập từ khóa...',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
                  searchKeyword,
              child: const Text(
                'Tìm kiếm',
              ),
            ),

            const SizedBox(height: 20),

            Text(
              found
                  ? 'Tìm thấy từ khóa'
                  : 'Không tìm thấy',
              style:
                  const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}