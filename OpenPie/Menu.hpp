//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_MENU_HPP
#define OPENPIE_MENU_HPP

#include "Signal.hpp"
#include "TransparentWindow.hpp"

#include <iostream>

namespace OpenPie {

//////////////////////////////////////////////////////////////////////////////////////////
// A base class for all menus. Derived classes have to implement it's behaviour.        //
//////////////////////////////////////////////////////////////////////////////////////////

class Menu {

 public:
  // emitted when some item is selected (occurs prior to on_close)
  Signal<std::string> onSelect;

  // emitted when no item has been selected (occurs prior to on_close)
  Signal<> onCancel;

  // emitted when the menu finally disappears from screen
  Signal<> onClose;

  virtual ~Menu() {}

  // sets the menu content which shall be displayed
  virtual void setContent(std::string const& menuDescription) = 0;

  // shows the menu on screen
  virtual void display(double x, double y) = 0;

 protected:
  // the window onto which the menu should be drawn
  TransparentWindow mWindow;
};

} // namespace OpenPie

#endif // OPENPIE_MENU_HPP
