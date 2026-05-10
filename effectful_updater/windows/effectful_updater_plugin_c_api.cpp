#include "include/effectful_updater/effectful_updater_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "effectful_updater_plugin.h"

void EffectfulUpdaterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  effectful_updater::EffectfulUpdaterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
