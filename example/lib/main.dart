// ignore_for_file: unused_import

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:webview_linux/webview_linux.dart';

import 'package:webview_linux/webview_linux_bindings_generated.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: CircularProgressIndicator.adaptive()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final w = Webview();
          w.create(0, nullptr);

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
          // w.loadHtml('<h1>Hello</h1>');
          w.navigate('https://flutter.dev');
          w.run();
        },
      ),
    );
  }
}
