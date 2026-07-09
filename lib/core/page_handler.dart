part of 'webview.dart';

mixin PageHandler on IWebview {
  set webviewPtr(Pointer<Void> res);

  /// Creates a new webview instance. If debug is non-zero - developer tools will
  /// be enabled (if the platform supports them). Window parameter can be a
  /// pointer to the native window handle. If it's non-null - then child WebView
  /// is embedded into the given parent window. Otherwise a new window is created.
  /// Depending on the platform, a GtkWindow, NSWindow or HWND pointer can be
  /// passed here.
  void create(int debug, Pointer<Void> window) {
    webviewPtr = webview_create(debug, window);
  }

  /// Updates the title of the native window. Must be called from the UI thread.
  void setTitle(String title) {
    final titlePtr = title.toNativeUtf8();
    webview_set_title(webviewPtr, titlePtr.cast<Char>());
    calloc.free(titlePtr);
  }

  /// Updates native window size. See WEBVIEW_HINT constants.
  void setSize({
    int width = 400,
    int height = 400,
    int hints = WEBVIEW_HINT_FIXED,
  }) {
    webview_set_size(webviewPtr, width, height, hints);
  }

  void loadHtml(String html) {
    navigate('data:text/html,$html');
  }
  
  void loadUrl(String url) {
    navigate(url);
  }

  @override
  void navigate(String urlOrSouce) {
    final c_urlOrSouce = urlOrSouce.toNativeUtf8();
    webview_navigate(webviewPtr, c_urlOrSouce.cast<Char>());
    malloc.free(c_urlOrSouce);
  }

  @override
  void destroy() {
    webview_destroy(webviewPtr);
  }

  @override
  void run() {
    webview_run(webviewPtr);
  }

  @override
  void terminate() {
    webview_terminate(webviewPtr);
  }
}
