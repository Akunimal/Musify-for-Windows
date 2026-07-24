#include "receive_sharing_intent/receive_sharing_intent_plugin.h"

namespace receive_sharing_intent {

void ReceiveSharingIntentPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto plugin = std::make_unique<ReceiveSharingIntentPlugin>();
  registrar->AddPlugin(std::move(plugin));
}

ReceiveSharingIntentPlugin::ReceiveSharingIntentPlugin() {}

ReceiveSharingIntentPlugin::~ReceiveSharingIntentPlugin() {}

}  // namespace receive_sharing_intent

extern "C" {
void ReceiveSharingIntentPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  receive_sharing_intent::ReceiveSharingIntentPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
}
