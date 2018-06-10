//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#include "Paths.hpp"

#include "Logger.hpp"

#include <experimental/filesystem>
#include <iostream>

namespace fs = std::experimental::filesystem;

namespace OpenPie {

bool                  Paths::m_initilized = false;
std::vector<fs::path> Paths::m_pluginDirectories;
fs::path              Paths::m_executable;

std::vector<fs::path> Paths::getPluginDirectories() {
  if (!m_initilized) init();
  return m_pluginDirectories;
}

fs::path Paths::getExecutable() {
  if (!m_initilized) init();
  return m_executable;
}

void Paths::init() {

  m_initilized = true;

  // get path of executable --------------------------------------------------------------
  {
    fs::path p = "/proc/self/exe";

    if (fs::exists(p) && fs::is_symlink(p)) {
      m_executable = fs::read_symlink(p);
    } else {
      OPENPIE_WARNING << "Failed to get path of executable!" << std::endl;
    }
  }

  // get plugin directories --------------------------------------------------------------
  {
    std::vector<fs::path> searchDirs = {"/usr/share/openpie/plugins",
                                        "/usr/local/share/openpie/plugins",
                                        "/opt/openpie/plugins",
                                        "~/.local/share/openpie/plugins",
                                        "~/.openpie/plugins"};

    if (m_executable != "") {
      searchDirs.push_back(
        m_executable.parent_path().generic_string() + "/../share/plugins");
    }

    for (auto dir : searchDirs) {
      if (fs::exists(dir)) { m_pluginDirectories.push_back(fs::canonical(dir)); }
    }
  }
}
} // namespace OpenPie
