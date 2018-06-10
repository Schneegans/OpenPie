//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_DAEMON_DBUSINTERFACE_HPP
#define OPENPIE_DAEMON_DBUSINTERFACE_HPP

#include <OpenPie/Signal.hpp>

#include <giomm.h>
#include <glibmm.h>
#include <string>

//////////////////////////////////////////////////////////////////////////////////////////
// The DBusInterface attaches an OpenPieServer to the DBus.                             //
//////////////////////////////////////////////////////////////////////////////////////////

class DBusInterface {

 public:
  static OpenPie::Signal<std::string, std::string> onShowMenu;
  static OpenPie::Signal<>                         onShowSettings;

  static void onSelect(std::string const& recipient, std::string const& item);
  static void onHover(std::string const& recipient, std::string const& item);
  static void onCancel(std::string const& recipient);

  static void bind(Glib::RefPtr<Gio::DBus::Connection> const& connection);

 private:
  static Glib::RefPtr<Gio::DBus::Connection> mConnection;
  static const std::string                   mIntropsepectionXML;
  static const Gio::DBus::InterfaceVTable    mOnMethodCalled;

  static gint mServiceID;
};

#endif // OPENPIE_DAEMON_DBUSINTERFACE_HPP
