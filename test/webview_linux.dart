// ignore_for_file: avoid_print, unused_import, non_constant_identifier_names

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:webview_linux/core/webview.dart';
import 'package:webview_linux/webview_linux_bindings_generated.dart';

void main() {
  final w = Webview();
  w.create(1, nullptr);

  w.setTitle("Dart Webview");
  w.setSize();
  w.onDOMContentLoaded(() {
    print('dom loaded');
  });
  w.addJsEventListener(
    callback: (result) {
      print('addJsEventListener: $result');
    },
  );
  w.loadHtml('<h1>Hello</h1>');
  // w.navigate('https://flutter.dev');
  w.run();
}
