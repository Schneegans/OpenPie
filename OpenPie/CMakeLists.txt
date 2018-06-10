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
add_library(OpenPie STATIC
    Logger.cpp
    MenuPlugin.cpp
    Paths.cpp
    TransparentWindow.cpp
)

target_include_directories(OpenPie 
    PUBLIC
        ${GTK_INCLUDE_DIRS}
)

target_link_libraries(OpenPie
    PRIVATE
        stdc++fs
    PUBLIC
        ${GTK_LIBRARIES}
)

# Install library -------------------------------------------------------------------------------- #
install(
    TARGETS
        OpenPie
    ARCHIVE DESTINATION
        ${CMAKE_INSTALL_PREFIX}/lib
)

