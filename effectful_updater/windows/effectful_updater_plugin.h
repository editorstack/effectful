#ifndef FLUTTER_PLUGIN_EFFECTFUL_UPDATER_PLUGIN_H_
#define FLUTTER_PLUGIN_EFFECTFUL_UPDATER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace effectful_updater {

class EffectfulUpdaterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  EffectfulUpdaterPlugin();

  virtual ~EffectfulUpdaterPlugin();

  // Disallow copy and assign.
  EffectfulUpdaterPlugin(const EffectfulUpdaterPlugin&) = delete;
  EffectfulUpdaterPlugin& operator=(const EffectfulUpdaterPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace effectful_updater

#endif  // FLUTTER_PLUGIN_EFFECTFUL_UPDATER_PLUGIN_H_
