#include "include/effectful_updater/effectful_updater_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>
#include <sys/stat.h>
#include <unistd.h>
#include <libgen.h>
#include <linux/limits.h>

#include <cstring>
#include <string>
#include <fstream>

#include "effectful_updater_plugin_private.h"

#define EFFECTFUL_UPDATER_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), effectful_updater_plugin_get_type(), EffectfulUpdaterPlugin))

struct _EffectfulUpdaterPlugin { GObject parent_instance; };

G_DEFINE_TYPE(EffectfulUpdaterPlugin, effectful_updater_plugin, g_object_get_type())

static void create_update_script(const char *executable_path) {
  char *temp_path = strdup(executable_path);
  const char *base_name = basename(temp_path);
  const std::string script =
      "#!/bin/bash\nsleep 1\ncp -R update/* .\nchmod +x " + std::string(executable_path) + "\n./" +
      std::string(base_name) + " &\nsleep 1\nrm update_script.sh\nrm -rf update\nexit\n";
  FILE *file = fopen("update_script.sh", "w");
  if (file) { fprintf(file, "%s", script.c_str()); fclose(file); chmod("update_script.sh", 0755); }
  free(temp_path);
}

static void run_update_script() {
  pid_t pid = fork();
  if (pid == 0) { execl("/bin/sh", "sh", "update_script.sh", NULL); _exit(1); }
}

static void effectful_updater_plugin_handle_method_call(EffectfulUpdaterPlugin *self, FlMethodCall *method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;
  const gchar *method = fl_method_call_get_name(method_call);

  if (strcmp(method, "restartApp") == 0) {
    char executable_path[PATH_MAX];
    ssize_t len = readlink("/proc/self/exe", executable_path, sizeof(executable_path) - 1);
    if (len != -1) { executable_path[len] = '\0'; create_update_script(executable_path); run_update_script(); exit(0); }
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else if (strcmp(method, "getExecutablePath") == 0) {
    char executable_path[PATH_MAX];
    ssize_t len = readlink("/proc/self/exe", executable_path, sizeof(executable_path) - 1);
    g_autoptr(FlValue) result = nullptr;
    if (len != -1) { executable_path[len] = '\0'; result = fl_value_new_string(executable_path); }
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
  fl_method_call_respond(method_call, response, nullptr);
}

static void effectful_updater_plugin_dispose(GObject *object) {
  G_OBJECT_CLASS(effectful_updater_plugin_parent_class)->dispose(object);
}

static void effectful_updater_plugin_class_init(EffectfulUpdaterPluginClass *klass) {
  G_OBJECT_CLASS(klass)->dispose = effectful_updater_plugin_dispose;
}

static void effectful_updater_plugin_init(EffectfulUpdaterPlugin *self) {}

static void method_call_cb(FlMethodChannel *channel, FlMethodCall *method_call, gpointer user_data) {
  effectful_updater_plugin_handle_method_call(EFFECTFUL_UPDATER_PLUGIN(user_data), method_call);
}

void effectful_updater_plugin_register_with_registrar(FlPluginRegistrar *registrar) {
  EffectfulUpdaterPlugin *plugin = EFFECTFUL_UPDATER_PLUGIN(g_object_new(effectful_updater_plugin_get_type(), nullptr));
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar), "effectful_updater", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb, g_object_ref(plugin), g_object_unref);
  g_object_unref(plugin);
}
