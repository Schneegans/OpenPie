//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#ifndef OPENPIE_LIB_PATHS_HPP
#define OPENPIE_LIB_PATHS_HPP

#include <experimental/filesystem>
#include <vector>

namespace OpenPie {

//////////////////////////////////////////////////////////////////////////////////////////
// A static class which stores all relevant paths used by OpenPie.                      //
// These depend upon the location from which the program was launched.                  //
//////////////////////////////////////////////////////////////////////////////////////////

class Paths {

 public:
  // Get all possible plugin diretories, that is
  //   /usr/share/openpie/plugins            (preferred for system wide installations)
  //   /usr/local/share/openpie/plugins
  //   /opt/openpie/plugins
  //   ~/.local/share/openpie/plugins        (preferred for local installations)
  //   ~/openpie/plugins
  //   {DAEMON_DIRECTORY}/../share/plugins   (used when not installed at all)
  static std::vector<std::experimental::filesystem::path> getPluginDirectories();

  // The path to the executable.
  static std::experimental::filesystem::path getExecutable();

 private:
  // Initializes all values above.
  static void init();

  static bool                                             m_initilized;
  static std::vector<std::experimental::filesystem::path> m_pluginDirectories;
  static std::experimental::filesystem::path              m_executable;
};

} // namespace OpenPie

#endif // OPENPIE_LIB_PATHS_HPP
