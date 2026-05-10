#include "effectful_updater_plugin.h"

#include <windows.h>
#include <Shlwapi.h>
#pragma comment(lib, "Shlwapi.lib")

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <fstream>
#include <memory>
#include <sstream>

namespace effectful_updater {

void EffectfulUpdaterPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar) {
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(), "effectful_updater", &flutter::StandardMethodCodec::GetInstance());
  auto plugin = std::make_unique<EffectfulUpdaterPlugin>();
  channel->SetMethodCallHandler([plugin_pointer = plugin.get()](const auto &call, auto result) {
    plugin_pointer->HandleMethodCall(call, std::move(result));
  });
  registrar->AddPlugin(std::move(plugin));
}

EffectfulUpdaterPlugin::EffectfulUpdaterPlugin() {}
EffectfulUpdaterPlugin::~EffectfulUpdaterPlugin() {}

static void CreateBatFile(const std::wstring &updateDir, const std::wstring &destDir, const wchar_t *executable_path) {
  auto toUtf8 = [](const wchar_t *ws) -> std::string {
    int size = WideCharToMultiByte(CP_UTF8, 0, ws, -1, NULL, 0, NULL, NULL);
    std::string s(size, 0);
    WideCharToMultiByte(CP_UTF8, 0, ws, -1, &s[0], size, NULL, NULL);
    s.pop_back();
    return s;
  };
  const std::string script =
      "@echo off\nchcp 65001 > NUL\ntimeout /t 2 /nobreak > NUL\n"
      "xcopy /E /I /Y \"" + toUtf8(updateDir.c_str()) + "\\*\" \"" + toUtf8(destDir.c_str()) + "\\\"\n"
      "rmdir /S /Q \"" + toUtf8(updateDir.c_str()) + "\"\n"
      "timeout /t 1 /nobreak > NUL\nstart \"\" \"" + toUtf8(executable_path) + "\"\n"
      "timeout /t 1 /nobreak > NUL\ndel update_script.bat\nexit\n";
  std::ofstream batFile("update_script.bat");
  batFile << script;
  batFile.close();
}

static void RunBatFile() {
  STARTUPINFO si = {sizeof(si)};
  PROCESS_INFORMATION pi;
  WCHAR cmdLine[] = L"cmd.exe /c update_script.bat";
  if (CreateProcess(NULL, cmdLine, NULL, NULL, FALSE, CREATE_NO_WINDOW, NULL, NULL, &si, &pi)) {
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
  }
}

static void RestartApp() {
  wchar_t executable_path[MAX_PATH];
  GetModuleFileNameW(NULL, executable_path, MAX_PATH);
  CreateBatFile(L"update", L".", executable_path);
  RunBatFile();
  ExitProcess(0);
}

void EffectfulUpdaterPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name() == "restartApp") {
    RestartApp();
    result->Success();
  } else if (method_call.method_name() == "getExecutablePath") {
    wchar_t executable_path[MAX_PATH];
    GetModuleFileNameW(NULL, executable_path, MAX_PATH);
    int size = WideCharToMultiByte(CP_UTF8, 0, executable_path, -1, NULL, 0, NULL, NULL);
    std::string pathStr(size, 0);
    WideCharToMultiByte(CP_UTF8, 0, executable_path, -1, &pathStr[0], size, NULL, NULL);
    result->Success(flutter::EncodableValue(pathStr));
  } else {
    result->NotImplemented();
  }
}

}  // namespace effectful_updater
