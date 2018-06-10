#--------------------------------------------------------------------------------------------------#
#                                                                                                  #
#         ,-.              ;-.          This file is part of OpenPie.                              #
#       /   \             |  ) o                                                                   #
#      |   | ;-. ,-. ;-. |-'  . ,-.     This software may be modified and distributed              #
#     \   / | | |-' | | |    | |-'      under the terms of the MIT license.                        #
#     `-'  |-' `-' ' ' '    ' `-'       See the LICENSE file for details.                          #
#         '                                                                                        #
#--------------------------------------------------------------------------------------------------#

# Compile sources -------------------------------------------------------------------------------- #
add_library(LinearMenu SHARED
    LinearMenu.cpp
    LinearMenuPlugin.cpp
)

target_include_directories(LinearMenu
    PRIVATE ${CMAKE_SOURCE_DIR}
)

target_link_libraries(LinearMenu 
    OpenPie
)

# Install library -------------------------------------------------------------------------------- #
install(
    TARGETS
        LinearMenu
    LIBRARY DESTINATION
        ${CMAKE_INSTALL_PREFIX}/share/plugins
)

