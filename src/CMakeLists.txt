cmake_minimum_required(VERSION 3.10)
project(webview_linux LANGUAGES C CXX)

# C++ 11 သို့မဟုတ် ပိုမြင့်တာကို သုံးဖို့ သတ်မှတ်ပေးပါ (webview အတွက် လိုအပ်ပါတယ်)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Linux မှာ library တွေကို ရှာဖို့ PkgConfig ကို သုံးပါမယ်
find_package(PkgConfig REQUIRED)
pkg_check_modules(WEBVIEW_DEPS REQUIRED webkit2gtk-4.1)
# (မှတ်ချက်: အပေါ်မှာ 4.1-dev သွင်းခဲ့ရင် webkit2gtk-4.1 လို့ ပြောင်းရေးပါ)

# add_executable(webview_linux
#     test/main.cpp
#     include/webview.h
#     wraper.cpp
#     # webview_linux.cpp
# )

add_library(webview_linux SHARED
    include/webview.h
    wraper.cpp
)

target_include_directories(webview_linux PRIVATE
    include
)

# WebKitGTK ရဲ့ Header files တည်နေရာတွေကို ချိတ်ပေးတာ
target_include_directories(webview_linux PRIVATE
    ${WEBVIEW_DEPS_INCLUDE_DIRS}
)

# WebKitGTK ရဲ့ Compile flags တွေနဲ့ Binary libraries တွေကို ချိတ်ပေးတာ
target_compile_options(webview_linux PRIVATE ${WEBVIEW_DEPS_CFLAGS_OTHER})
target_link_libraries(webview_linux PRIVATE ${WEBVIEW_DEPS_LIBRARIES})
