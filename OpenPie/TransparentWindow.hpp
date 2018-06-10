//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_TRANSPARENT_WINDOW_HPP
#define OPENPIE_TRANSPARENT_WINDOW_HPP

#include "Signal.hpp"

#include <gtkmm.h>

namespace OpenPie {

//////////////////////////////////////////////////////////////////////////////////////////
//  An invisible window. Used to draw menus onto.                                       //
//////////////////////////////////////////////////////////////////////////////////////////

class TransparentWindow : public Gtk::Window {
 public:
  // those get emitted when the according action occurs
  // Signal<float, float>           onMouseMove;
  // Signal<Key>                    onKeyDown;
  // Signal<Key>                    onKeyUp;
  Signal<Cairo::Context, double> onDraw;

  // C'tor, sets up the window
  TransparentWindow() {}

  // // Gets the center position of the window
  // std::pair<double, double> getCenter_pos();

  // // Gets the current pointer position
  // std::pair<double, double> getPointer_pos();

  // // grabs the input focus
  // void add_grab();

  // // releases the input focus
  // void remove_grab();

  //   //////////////////////////////////////////////////////////////////////////////
  //   //                         private stuff                                    //
  //   //////////////////////////////////////////////////////////////////////////////

  //   ////////////////////////// member variables //////////////////////////////////

  //   // The background image used for fake transparency if
  //   // has_compositing_ is false.
  //   private Image background_ { get; private set; default=null; }

  //   // True, if the screen supports compositing.
  //   private bool has_compositing_ = false;

  //   private bool button_down_ = false;

  //   // The embedded clutter stage
  //   private Clutter.Stage     stage_ = null;
  //   private GtkClutter.Embed  embed_ = null;
};

} // namespace OpenPie

#endif // OPENPIE_TRANSPARENT_WINDOW_HPP
