#include <iostream>

#include "webview.h"

void callNativeCallback(const char *seq, const char *req, void *arg) {
  std::cout << "\n[Scraped Data]: " << req << "\n\n";
}

int main() {
  auto w = webview_create(1, nullptr);
  webview_set_size(w, 400, 400, 0);
  webview_set_title(w, "Webview Scraper");

  // 1. C++ ဘက်ကနေ "callnative" ဆိုတဲ့ နာမည်နဲ့ ပေါင်းကူးတံတား ဆောက်ထားမယ်
  webview_bind(w, "callnative", callNativeCallback, nullptr);

  // 2. စာမျက်နှာတစ်ခုခု မပွင့်ခင် (Load မလုပ်ခင်) မှာ ကိုယ့် JS ကို ကြိုပြီး Inject လုပ်ထားမယ်
  // DOM တည်ဆောက်ပြီးတာနဲ့ callnative ကို လှမ်းခေါ်ဖို့ စောင့်ခိုင်းထားတာပါ
  webview_init(w,
               "document.addEventListener('DOMContentLoaded', function() {"
               "  setTimeout(() => {"
               "    try {"
               "      const pageTitle = document.title;"
               "      const mainHeading = document.querySelector('h1') ? "
               "document.querySelector('h1').innerText : 'No H1 Found';"
               "      const result = JSON.stringify({ title: pageTitle, "
               "heading: mainHeading });"
               "      window.callnative(result);"
               "    } catch(e) {"
               "      window.callnative('Error: ' + e.message);"
               "    }"
               "  }, 2000);"  // Page load ပြီးသွားရင် တခြား dynamic element
                              // တွေတက်လာအောင် ၂ စက္ကန့် စောင့်ပေးမယ်
               "});");

  // 3. ပြီးမှ သွားမယ့် URL ကို ခေါ်မယ်
  webview_navigate(w, "https://flutter.dev");
  // webview_navigate(w, "data:text/html,<html><h1>Hello</h1></html>");

  webview_run(w);
  return 0;
}