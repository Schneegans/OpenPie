//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#include "DBusInterface.hpp"

#include <OpenPie/Logger.hpp>

#include <giomm.h>
#include <glibmm.h>

OpenPie::Signal<std::string, std::string> DBusInterface::onShowMenu;
OpenPie::Signal<>                         DBusInterface::onShowSettings;
Glib::RefPtr<Gio::DBus::Connection>       DBusInterface::mConnection;

const Gio::DBus::InterfaceVTable DBusInterface::mOnMethodCalled(
  [](
    const Glib::RefPtr<Gio::DBus::Connection>&       connection,
    const Glib::ustring&                             sender,
    const Glib::ustring&                             object,
    const Glib::ustring&                             interface,
    const Glib::ustring&                             method,
    const Glib::VariantContainerBase&                parameters,
    const Glib::RefPtr<Gio::DBus::MethodInvocation>& invocation) {

    invocation->return_value(Glib::VariantContainerBase());

    if (method == "ShowMenu") {
      Glib::Variant<Glib::ustring> param;
      parameters.get_child(param);
      const Glib::ustring menuDescription = param.get();
      onShowMenu.emit(menuDescription, invocation->get_sender());

    } else if (method == "ShowSettings") {
      onShowSettings.emit();
    }
  });

const std::string DBusInterface::mIntropsepectionXML = R"(
<node>
  <interface name="org.openpie.Daemon.MenuService">
    <method name="ShowMenu">
      <arg name="description" type="s" direction="in"/>
    </method>
    <method name="ShowSettings">
    </method>
    <signal name="OnSelect">
        <arg name="path"type="s"/>
    </signal>
    <signal name="OnHover">
        <arg name="path"type="s"/>
    </signal>
    <signal name="OnCancel">
    </signal>
  </interface>
</node>
)";

gint DBusInterface::mServiceID = 0;

void DBusInterface::bind(Glib::RefPtr<Gio::DBus::Connection> const& connection) {
  mConnection = connection;
  Glib::RefPtr<Gio::DBus::NodeInfo> introspectionData =
    Gio::DBus::NodeInfo::create_for_xml(mIntropsepectionXML);
  mServiceID = connection->register_object(
    "/org/openpie/Daemon/MenuService",
    introspectionData->lookup_interface(),
    mOnMethodCalled);
}

void DBusInterface::onSelect(std::string const& recipient, std::string const& item) {
  Glib::VariantContainerBase response =
    Glib::VariantContainerBase::create_tuple(Glib::Variant<Glib::ustring>::create(item));
  mConnection->emit_signal(
    "/org/openpie/Daemon/MenuService",
    "org.openpie.Daemon.MenuService",
    "OnSelect",
    recipient,
    response);
}

void DBusInterface::onHover(std::string const& recipient, std::string const& item) {
  Glib::VariantContainerBase response =
    Glib::VariantContainerBase::create_tuple(Glib::Variant<Glib::ustring>::create(item));
  mConnection->emit_signal(
    "/org/openpie/Daemon/MenuService",
    "org.openpie.Daemon.MenuService",
    "OnHover",
    recipient,
    response);
}

void DBusInterface::onCancel(std::string const& recipient) {
  mConnection->emit_signal(
    "/org/openpie/Daemon/MenuService",
    "org.openpie.Daemon.MenuService",
    "OnCancel",
    recipient);
}
