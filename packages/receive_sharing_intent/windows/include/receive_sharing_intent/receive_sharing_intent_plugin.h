#ifndef FLUTTER_PLUGIN_RECEIVE_SHARING_INTENT_PLUGIN_H_
#define FLUTTER_PLUGIN_RECEIVE_SHARING_INTENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <memory>

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

#endif  // FLUTTER_PLUGIN_RECEIVE_SHARING_INTENT_PLUGIN_H_
