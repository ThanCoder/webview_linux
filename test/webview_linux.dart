// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:webview_linux/webview_linux_bindings_generated.dart';

void callback(Pointer<Char> status, Pointer<Char> res, Pointer<Void> arg) {
  print('result: ${res.cast<Utf8>().toDartString()}');
}

void main() {
  final callbackPtr =
      NativeCallable<
        Void Function(Pointer<Char>, Pointer<Char>, Pointer<Void>)
      >.isolateLocal(callback);

  final w = webview_create(1, nullptr);
  final titlePtr = "webview".toNativeUtf8();
  webview_set_title(w, titlePtr.cast<Char>());
  calloc.free(titlePtr);

  webview_set_size(w, 400, 400, 0);
  final c_caller_name = 'callNative'.toNativeUtf8();
  // js bind
  webview_bind(
    w,
    c_caller_name.cast<Char>(),
    callbackPtr.nativeFunction,
    nullptr,
  );
  calloc.free(c_caller_name);
  final c_js =
      '''
document.addEventListener('DOMContentLoaded',function(){
   setTimeout(() => {
     window.callNative("hello from js")
   }, 2000);
})
  '''
          .toNativeUtf8();
  webview_init(w, c_js.cast<Char>());

  final urlPtr = 'https://flutter.dev/'.toNativeUtf8();

  webview_navigate(w, urlPtr.cast<Char>());
  calloc.free(urlPtr);

  webview_run(w);
  webview_destroy(w);
}
