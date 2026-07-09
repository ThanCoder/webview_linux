import 'dart:ffi';

abstract class IWebview {
  Pointer<Void> get webviewPtr;

  /// Navigates webview to the given URL. URL may be a data URI, i.e.
  /// "data:text/text,<html>...</html>". It is often ok not to url-encode it
  /// properly, webview will re-encode it for you.
  void navigate(String urlOrSouce);

  /// Runs the main loop until it's terminated. After this function exits - you
  /// must destroy the webview.
  void run();

  /// Destroys a webview and closes the native window.
  void destroy();

  /// Stops the main loop. It is safe to call this function from another other
  /// background thread.
  void terminate();

  void dispose();
}
