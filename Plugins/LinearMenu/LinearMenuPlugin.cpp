//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#include "LinearMenuPlugin.hpp"

#include "LinearMenu.hpp"

#include <OpenPie/Logger.hpp>

extern "C" OpenPie::MenuPlugin* createMenuPlugin() { return new LinearMenuPlugin(); }
extern "C" void destroyMenuPlugin(OpenPie::MenuPlugin* menu) { delete menu; }

std::shared_ptr<OpenPie::Menu> LinearMenuPlugin::createMenu() const {
  return std::make_shared<LinearMenu>(mPluginDirectory);
}

std::string LinearMenuPlugin::getName() const { return "LinearMenu"; }

std::string LinearMenuPlugin::getVersion() const { return "0.1"; }

std::string LinearMenuPlugin::getAuthor() const { return "Simon Schneegans"; }

std::string LinearMenuPlugin::getEmail() const { return "code@simonschneegans.de"; }

std::string LinearMenuPlugin::getHomepage() const {
  return "http://www.simonschneegans.de";
}

std::string LinearMenuPlugin::getDescription() const {
  return "The most simple menu type. Just a list of entries.";
}
