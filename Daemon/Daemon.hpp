//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_DAEMON_DAEMON_HPP
#define OPENPIE_DAEMON_DAEMON_HPP

#include "PluginFactory.hpp"

#include <gtkmm/application.h>

//////////////////////////////////////////////////////////////////////////////////////////
// The Daemon opens the DBus-interface and listens for incoming requests                //
//////////////////////////////////////////////////////////////////////////////////////////

class Daemon : public Gtk::Application {
 public:
  // The current version of OpenPie
  const static std::string version;

  Daemon();

  // The beginning of everything
  void on_startup() override;
  void on_activate() override;

  void showSettings();

 private:
  PluginFactory mPlugins;
};

#endif // OPENPIE_DAEMON_DAEMON_HPP
