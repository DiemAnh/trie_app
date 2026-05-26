import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<void> saveTrie(
    String data,
  ) async {
    final dir =
        await getApplicationDocumentsDirectory();

    final file = File(
      '${dir.path}/trie.json',
    );

    await file.writeAsString(data);
  }

  static Future<String?> loadTrie() async {
    final dir =
        await getApplicationDocumentsDirectory();

    final file = File(
      '${dir.path}/trie.json',
    );

    if (await file.exists()) {
      return await file.readAsString();
    }

    return null;
  }
}