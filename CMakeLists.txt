# ------------------------------------------------------------------------------------------------ #
#                                                                                                  #
#         ,-.              ;-.          This file is part of OpenPie.                              #
#       /   \             |  ) o                                                                   #
#      |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed              #
#     \   / | | |-' | | |    | |-'      under the terms of the MIT license.                        #
#     `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.                          #
#         '                                                                                        #
# ------------------------------------------------------------------------------------------------ #

cmake_minimum_required(VERSION 3.1)

project(OpenPie)

# Configure and find libraries ------------------------------------------------------------------- #
find_package(PkgConfig)

pkg_check_modules(GTK REQUIRED gtkmm-3.0)

set(CMAKE_CXX_STANDARD 17)
add_compile_options("-fPIC")

# Add shared library ----------------------------------------------------------------------------- #
add_subdirectory(OpenPie)

# Add daemon executable -------------------------------------------------------------------------- #
add_subdirectory(Daemon)

# Add plugins ------------------------------------------------------------------------------------ #
add_subdirectory(Plugins)
