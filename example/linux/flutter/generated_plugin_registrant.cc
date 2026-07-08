//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <fl_view_bridge_linux/fl_view_bridge_linux_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) fl_view_bridge_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlViewBridgeLinuxPlugin");
  fl_view_bridge_linux_plugin_register_with_registrar(fl_view_bridge_linux_registrar);
}
