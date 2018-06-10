//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_DAEMON_PLUGINFACTORY_HPP
#define OPENPIE_DAEMON_PLUGINFACTORY_HPP

#include <OpenPie/MenuPlugin.hpp>

#include <experimental/filesystem>
#include <functional>
#include <map>
#include <vector>

//////////////////////////////////////////////////////////////////////////////////////////
// This class tries to load all shared objects from given directories as plugins. It    //
// stores a map of plugin names and their associated plugins. It can be used to create  //
// instances of the loaded plugins.                                                     //
//////////////////////////////////////////////////////////////////////////////////////////

class PluginFactory {

 public:
  void loadFromDirectory(std::experimental::filesystem::path const& directory);

  std::shared_ptr<OpenPie::MenuPlugin> getPlugin(std::string const& name) const;

 private:
  struct MenuPluginData {
    std::function<OpenPie::MenuPlugin*()>     mCreateFunc;
    std::function<void(OpenPie::MenuPlugin*)> mDeleteFunc;
    void*                                     mSharedObject;
  };

  std::map<std::string, std::shared_ptr<OpenPie::MenuPlugin>> mPlugins;
};

#endif // OPENPIE_DAEMON_PLUGINFACTORY_HPP
