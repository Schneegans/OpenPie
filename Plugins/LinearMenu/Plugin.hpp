//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_PLUGINS_LINEAR_MENU_HPP
#define OPENPIE_PLUGINS_LINEAR_MENU_HPP

#include <OpenPie/MenuPlugin.hpp>

//////////////////////////////////////////////////////////////////////////////////////////

class LinearMenu : public OpenPie::MenuPlugin {
 public:
  LinearMenu();
  ~LinearMenu();

  // MenuPlugin interface ----------------------------------------------------------------
  void        init(std::string const& pluginDirectory) override;
  std::string getName() const override;
  std::string getVersion() const override;
  std::string getAuthor() const override;
  std::string getEmail() const override;
  std::string getHomepage() const override;
  std::string getDescription() const override;

  // Menu interface ----------------------------------------------------------------------
  void setContent(std::string menuDescription) override;
  void display(double x, double y) override;
};

#endif // OPENPIE_PLUGINS_LINEAR_MENU_HPP
