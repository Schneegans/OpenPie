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

#include <OpenPie/Menu.hpp>

//////////////////////////////////////////////////////////////////////////////////////////

class LinearMenu : public OpenPie::Menu {
 public:
  LinearMenu(std::string const& pluginDirectory);
  ~LinearMenu();

  void setContent(std::string const& menuDescription) override;
  void display(double x, double y) override;
};

#endif // OPENPIE_PLUGINS_LINEAR_MENU_HPP
