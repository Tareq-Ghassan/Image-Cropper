#include "include/doc_scanner_sdk/doc_scanner_sdk_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace doc_scanner_sdk {

class DocScannerSdkPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DocScannerSdkPlugin();

  virtual ~DocScannerSdkPlugin();

  // Disallow copy and assign.
  DocScannerSdkPlugin(const DocScannerSdkPlugin&) = delete;
  DocScannerSdkPlugin& operator=(const DocScannerSdkPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void DocScannerSdkPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "doc_scanner_sdk",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<DocScannerSdkPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

DocScannerSdkPlugin::DocScannerSdkPlugin() {}

DocScannerSdkPlugin::~DocScannerSdkPlugin() {}

void DocScannerSdkPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getVersion") == 0) {
    result->Success(flutter::EncodableValue("1.0.0"));
  } else {
    result->NotImplemented();
  }
}

}  // namespace doc_scanner_sdk
