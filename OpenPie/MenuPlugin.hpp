//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_MENUPLUGIN_HPP
#define OPENPIE_MENUPLUGIN_HPP

#include <memory>
#include <string>

namespace OpenPie {

class Menu;

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

class MenuPlugin {

 public:
  virtual ~MenuPlugin() {}

  // this gets set by the openpie daemon and can be used to access resources
  virtual void setPluginDirectory(std::string const& pluginDirectory);

  virtual std::shared_ptr<Menu> createMenu() const = 0;

  // name of the plugin, e.g. "Cool Menu"
  virtual std::string getName() const = 0;

  // version string, e.g. "2.0"
  virtual std::string getVersion() const = 0;

  // name of the main author, e.g. "John Doe"
  virtual std::string getAuthor() const = 0;

  // email of the main author, e.g. "john.doe@sample.org"
  virtual std::string getEmail() const = 0;

  // homepage of the main author, e.g. "www.sample.org"
  virtual std::string getHomepage() const = 0;

  // a description of the menu plugin, e.g. "A Cool Menu is a very cool menu
  //                                         because ... and ..."
  virtual std::string getDescription() const = 0;

 protected:
  std::string mPluginDirectory;
};

// the types of the class factories
typedef OpenPie::MenuPlugin* create_menu_plugin_t();
typedef void                 destroy_menu_plugin_t(OpenPie::MenuPlugin*);

} // namespace OpenPie

#endif // OPENPIE_MENUPLUGIN_HPP
