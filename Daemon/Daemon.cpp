//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#include "Daemon.hpp"

#include "DBusInterface.hpp"

#include <OpenPie/Logger.hpp>
#include <OpenPie/Menu.hpp>
#include <OpenPie/MenuPlugin.hpp>
#include <OpenPie/Paths.hpp>

#include <iostream>
#include <signal.h>
#include <string>

const std::string Daemon::version = "0.1.0";

namespace internal {
std::function<void()> staticQuitFunc;
} // namespace internal

Daemon::Daemon()
  : Gtk::Application("org.openpie.Daemon", Gio::APPLICATION_HANDLES_COMMAND_LINE) {

  add_main_option_entry(
    Gio::Application::OPTION_TYPE_BOOL,
    "settings",
    's',
    "Show the OpenPie settings dialog");

  add_main_option_entry(
    Gio::Application::OPTION_TYPE_BOOL,
    "version",
    'v',
    "Show version information for OpenPie");

  signal_handle_local_options().connect(
    [this](Glib::RefPtr<Glib::VariantDict> const& options) {
      bool value = false;
      if (options->lookup_value("version", value)) {
        OPENPIE_MESSAGE << "OpenPie v" << version << std::endl;
        return 0;
      }

      if (is_remote()) { OPENPIE_MESSAGE << "OpenPie is already running." << std::endl; }
      return -1;
    });

  signal_command_line().connect(
    [this](Glib::RefPtr<Gio::ApplicationCommandLine> const& cmd) {
      auto options = cmd->get_options_dict();
      bool value   = false;
      if (options->lookup_value("settings", value)) { showSettings(); }
      return 0;
    },
    false);

  register_application();
}

void Daemon::on_startup() {
  auto dbusConnection = get_dbus_connection();
  DBusInterface::bind(dbusConnection);

  DBusInterface::onShowMenu.connect(
    [](std::string const& description, std::string const& sender) {
      OPENPIE_MESSAGE << "Show menu: " + description << std::endl;
      DBusInterface::onSelect(sender, "foo");
      // DBusInterface::onCancel(sender);
    });

  DBusInterface::onShowSettings.connect([this]() { showSettings(); });

  // be friendly
  OPENPIE_MESSAGE << "Welcome to OpenPie v" + version + "!" << std::endl;

  // do not quit application when there is no window
  hold();

  // load menu plugins from all possible directories
  auto pluginDirectories = OpenPie::Paths::getPluginDirectories();
  for (auto pluginDirectory : pluginDirectories) {
    mPlugins.loadFromDirectory(pluginDirectory);
  }

  // auto plugin = mPlugins.getPlugin("LinearMenu");
  // auto menu   = plugin->createMenu();
  // menu->setContent("foo");

  // print a nifty message when being killed
  internal::staticQuitFunc = [this]() {
    std::cout << std::endl;
    OPENPIE_MESSAGE << "Bye!" << std::endl;
    release();
  };

  signal(SIGINT, [](int i) { internal::staticQuitFunc(); });
  signal(SIGTERM, [](int i) { internal::staticQuitFunc(); });

  Gtk::Application::on_startup();
}

void Daemon::on_activate() { OPENPIE_MESSAGE << "on_activate" << std::endl; }

void Daemon::showSettings() { OPENPIE_MESSAGE << "Show Settings!" << std::endl; }
