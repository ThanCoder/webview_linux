// ignore_for_file: avoid_print

import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final packageName = input.packageName;
    final file = File(
      '${input.packageRoot.toFilePath()}src/lib/libwebview_linux.so',
    );
    output.assets.code.add(
      CodeAsset(
        package: packageName,
        name: '${packageName}_bindings_generated.dart',
        linkMode: DynamicLoadingBundled(),
        file: file.uri,
      ),
    );
  });
}
