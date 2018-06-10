//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//        ,-.              ;-.          This file is part of OpenPie.                   //
//      /   \             |  ) o                                                        //
//     |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed   //
//    \   / | | |-' | | |    | |-'      under the terms of the MIT license.             //
//    `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.               //
//        '                                                                             //
//////////////////////////////////////////////////////////////////////////////////////////

#include <OpenPie/Logger.hpp>

#include "Daemon.hpp"

int main(int argc, char** argv) {
  try {
    Daemon daemon;
    return daemon.run(argc, argv);

  } catch (std::runtime_error const& e) {
    OPENPIE_ERROR << e.what() << std::endl;

  } catch (...) {
    OPENPIE_ERROR << "Got critical uncaught exception. This should not happen!"
                  << std::endl;
  }
  return 1;
}
