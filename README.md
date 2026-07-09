# webview_linux

A lightweight Dart FFI binding package for embedding WebKitGTK 4.1 webview into Linux applications. 

## Features

- **WebKitGTK 4.1 Integration**: Uses modern, stable WebKit components for Linux (Ubuntu/Debian).
- **HTML/URL Loading**: Easily load local HTML strings or navigate to remote websites.
- **JavaScript Execution**: Run JavaScript from Dart and register listeners for DOM events.
- **Minimal Footprint**: Low memory consumption utilizing native C/C++ FFI bindings.

## Prerequisites

Before running any Dart application using this package, you must install the WebKitGTK 4.1 development libraries on your Linux system.

### On Ubuntu / Debian:
```bash
sudo apt-get update
sudo apt-get install libwebkit2gtk-4.1-dev
```

## Installation

Add `webview_linux` to your `pubspec.yaml` file:

```yaml
dependencies:
  webview_linux: latest # version
    path: /path/to/your/local/package # Or git repository link
```

## Usage

Here is a basic example showing how to initialize, configure, and run a webview instance in Dart:

```dart
import 'dart:ffi';
import 'package:webview_linux/webview_linux.dart';

void main() {
  // Initialize the Webview
  final w = Webview();
  w.create(1, nullptr);

  // Set Window Properties
  w.setTitle("Dart Webview");
  w.setSize();

  // Listen to DOM Events
  w.onDOMContentLoaded(() {
    print('DOM successfully loaded');
  });

  // Listen to JavaScript events/callbacks
  w.addJsEventListener(
    callback: (result) {
      print('addJsEventListener: $result');
    },
  );

  // Load Content (Choose between loading HTML or Navigating to a URL)
  w.loadHtml('<h1>Hello from Dart Webview!</h1>');
  // w.navigate('[https://flutter.dev](https://flutter.dev)');

  // Run the GTK Main Loop
  w.run();
}
```

## API Documentation

### `void create(int debug, Pointer<Void> window)`
Initializes the GTK instance and creates a new WebKitWebView widget inside a native GTK window.

### `void setTitle(String title)`
Sets the application window title.

### `void setSize()`
Sets the default predefined window dimensions for the application.

### `void loadHtml(String html)`
Renders a raw HTML string directly inside the webview.

### `void navigate(String url)`
Navigates the webview to the specified HTTP/HTTPS URL address.

### `void onDOMContentLoaded(Function callback)`
Registers a callback that fires once the document object model (DOM) has fully loaded.

### `void run()`
Starts the native GTK main loop, blocking execution and displaying the UI window until closed.

## Repository

- **GitHub**: [https://github.com/ThanCoder/webview_linux.git](https://github.com/ThanCoder/webview_linux.git)

## License

This project is licensed under the MIT License - see the LICENSE file for details.