//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_PLUGINS_LINEAR_MENU_PLUGIN_HPP
#define OPENPIE_PLUGINS_LINEAR_MENU_PLUGIN_HPP

#include <OpenPie/MenuPlugin.hpp>

//////////////////////////////////////////////////////////////////////////////////////////

class LinearMenuPlugin : public OpenPie::MenuPlugin {
 public:
  std::shared_ptr<OpenPie::Menu> createMenu() const override;

  std::string getName() const override;
  std::string getVersion() const override;
  std::string getAuthor() const override;
  std::string getEmail() const override;
  std::string getHomepage() const override;
  std::string getDescription() const override;
};

#endif // OPENPIE_PLUGINS_LINEAR_MENU_PLUGIN_HPP
