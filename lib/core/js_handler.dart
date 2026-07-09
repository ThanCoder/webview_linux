part of 'webview.dart';

typedef JsHandlerCallback = void Function(String result);
typedef JsHandlerNativeCallback =
    NativeCallable<Void Function(Pointer<Char>, Pointer<Char>, Pointer<Void>)>;

mixin JsHandler on IWebview {
  static final Map<String, JsHandlerCallback> _callbacks = {};
  static final Map<String, JsHandlerNativeCallback> _callables = {};
  static int _autoId = 0;
  static int get _generatedId {
    _autoId++;
    return _autoId;
  }

  static void _jsCallback(String id, Pointer<Char> reqPtr) {
    // print('_jsCallback:ID: $id');
    final res = reqPtr.cast<Utf8>().toDartString();
    if (_callbacks.containsKey(id)) {
      final callback = _callbacks[id]!;
      callback(res);
    }
  }

  /// Binds a native C callback so that it will appear under the given name as a
  /// global JavaScript function. Internally it uses webview_init(). Callback
  /// receives a request string and a user-provided argument pointer. Request
  /// string is a JSON array of all the arguments passed to the JavaScript
  /// function.
  void bind(String bindName, JsHandlerCallback callback) {
    if (_callables.containsKey(bindName)) {
      _callables[bindName]?.close();
      _callables.remove(bindName);
    }

    // Callback ကို Map ထဲမှာ သိမ်းမယ်
    _callbacks[bindName] = callback;

    // NativeCallable အသစ်ဆောက်ပြီး Map ထဲမှာ သိမ်းမယ်
    final callable =
        NativeCallable<
          Void Function(Pointer<Char>, Pointer<Char>, Pointer<Void>)
        >.isolateLocal((
          Pointer<Char> id,
          Pointer<Char> req,
          Pointer<Void> arg,
        ) {
          _jsCallback(bindName, req);
        }); // တိုက်ရိုက် _jsCallback ကို လှမ်းပေးလို့ရပါတယ်

    _callables[bindName] = callable;

    final c_bind_name = bindName.toNativeUtf8();
    webview_bind(
      webviewPtr,
      c_bind_name.cast<Char>(),
      callable.nativeFunction,
      nullptr,
    );
    calloc.free(c_bind_name);
  }

  /// Evaluates arbitrary JavaScript code. Evaluation happens asynchronously, also
  /// the result of the expression is ignored. Use RPC bindings if you want to
  /// receive notifications about the results of the evaluation.
  void eval(String jsCode) {
    final c_js_code = jsCode.toNativeUtf8();
    webview_eval(webviewPtr, c_js_code.cast<Char>());
    calloc.free(c_js_code);
  }

  /// Injects JavaScript code at the initialization of the new page. Every time
  /// the webview will open a the new page - this initialization code will be
  /// executed. It is guaranteed that code is executed before window.onload.
  void init(String jsCode) {
    final c_js = jsCode.toNativeUtf8();
    webview_init(webviewPtr, c_js.cast<Char>());
    calloc.free(c_js);
  }

  /// Js Event Listener
  void addJsEventListener({
    String eventName = 'DOMContentLoaded',
    int delayTime = 2000,
    required JsHandlerCallback callback,
  }) {
    // Event တစ်ခုစီအတွက် သီးသန့် Bind Name ဖြစ်သွားအောင် eventName ကိုပါ တွဲပေးလိုက်မယ်
    final nativeBindName = 'nativeJs_${eventName}_id_$_generatedId';

    bind(nativeBindName, callback);
    init('''
      document.addEventListener('$eventName', function(){
         setTimeout(() => {
           window.$nativeBindName("$eventName")
         }, $delayTime);
      })
    ''');
  }

  void onDOMContentLoaded(void Function() callback) {
    addJsEventListener(callback: (result) => callback());
  }

  void disposeJsHandler() {
    for (final callable in _callables.values) {
      callable.close();
    }
    _callables.clear();
    _callbacks.clear();
  }
}
