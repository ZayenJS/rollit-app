import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

Future<void> clearTempCache() async {
  debugPrint('🧹 Cleaning cache...');
  final dir = await getTemporaryDirectory();
  if (!await dir.exists()) return;

  final files = await dir.list(recursive: true).toList();
  final List<Future> futures = [];

  for (final file in files) {
    if (file is! File) continue;

    futures.add(file.delete().catchError((_) {}));
  }

  await Future.wait(futures);
}
