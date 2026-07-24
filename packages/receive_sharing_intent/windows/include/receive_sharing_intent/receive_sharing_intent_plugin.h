#ifndef FLUTTER_PLUGIN_RECEIVE_SHARING_INTENT_PLUGIN_H_
#define FLUTTER_PLUGIN_RECEIVE_SHARING_INTENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter_plugin_registrar.h>
#include <memory>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FLUTTER_PLUGIN_EXPORT __declspec(dllimport)
#endif

namespace receive_sharing_intent {

class ReceiveSharingIntentPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  ReceiveSharingIntentPlugin();

  virtual ~ReceiveSharingIntentPlugin();

 private:
  // Disallow copy and assign.
  ReceiveSharingIntentPlugin(const ReceiveSharingIntentPlugin&);
  ReceiveSharingIntentPlugin& operator=(const ReceiveSharingIntentPlugin&);
};

}  // namespace receive_sharing_intent

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void ReceiveSharingIntentPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // FLUTTER_PLUGIN_RECEIVE_SHARING_INTENT_PLUGIN_H_
