//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#include "PluginFactory.hpp"

#include <OpenPie/Logger.hpp>
#include <OpenPie/MenuPlugin.hpp>
#include <dlfcn.h>

namespace fs = std::experimental::filesystem;

// returns a menu instance of the given menu type
std::shared_ptr<OpenPie::MenuPlugin> PluginFactory::getPlugin(
  std::string const& name) const {

  auto menu = mPlugins.find(name);

  if (menu == mPlugins.end()) {
    OPENPIE_ERROR << "Plugin '" << name << "' not found!" << std::endl;
    return nullptr;
  }

  return menu->second;
}

void PluginFactory::loadFromDirectory(
  std::experimental::filesystem::path const& directory) {
  for (auto& entry : fs::directory_iterator(directory)) {
    if (fs::is_directory(entry)) {
      loadFromDirectory(entry);
    } else if (fs::is_regular_file(entry) && entry.path().extension() == ".so") {

      // load the plugin
      void* sharedObject = dlopen(entry.path().string().c_str(), RTLD_LAZY);
      if (!sharedObject) {
        OPENPIE_ERROR << "Failed to load plugin: " << dlerror() << std::endl;
        continue;
      }

      // reset errors
      dlerror();

      // load the symbols
      auto createMenuPlugin =
        (OpenPie::create_menu_plugin_t*)dlsym(sharedObject, "createMenuPlugin");

      const char* dlsym_error = dlerror();
      if (dlsym_error) {
        OPENPIE_ERROR << "Cannot load symbol 'createMenuPlugin': " << dlsym_error
                      << std::endl;
        continue;
      }

      auto destroyMenuPlugin =
        (OpenPie::destroy_menu_plugin_t*)dlsym(sharedObject, "destroyMenuPlugin");

      dlsym_error = dlerror();
      if (dlsym_error) {
        OPENPIE_ERROR << "Cannot load symbol 'destroyMenuPlugin': " << dlsym_error
                      << std::endl;
        return;
      }

      // create an instance of the class
      auto menuPlugin = std::shared_ptr<OpenPie::MenuPlugin>(
        createMenuPlugin(),
        [destroyMenuPlugin, sharedObject](OpenPie::MenuPlugin* plugin) {
          destroyMenuPlugin(plugin);
          dlclose(sharedObject);
        });

      // use the class
      auto pluginName = menuPlugin->getName();
      menuPlugin->setPluginDirectory(directory.string());

      OPENPIE_MESSAGE << "Successfully loaded menu plugin '" << pluginName << "'!"
                      << std::endl;

      mPlugins[pluginName] = menuPlugin;
    }
  }
}
