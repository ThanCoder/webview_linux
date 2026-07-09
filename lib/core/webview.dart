import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:webview_linux/core/i_webview.dart';
import 'package:webview_linux/webview_linux_bindings_generated.dart';

part 'page_handler.dart';
part 'js_handler.dart';

class Webview extends IWebview with PageHandler, JsHandler {
  @override
  Pointer<Void> webviewPtr = nullptr;

  @override
  void dispose() {
    disposeJsHandler();
  }
}
