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
add_executable(openpie-daemon
    Daemon.cpp
    DBusInterface.cpp
    main.cpp
    OpenPieServer.cpp
    PluginFactory.cpp
)

target_include_directories(openpie-daemon
    PRIVATE ${CMAKE_SOURCE_DIR}
)

target_link_libraries(openpie-daemon 
    PRIVATE
        OpenPie
        dl
)

# Install executable ----------------------------------------------------------------------------- #
install(
    TARGETS
        openpie-daemon
    RUNTIME DESTINATION
        ${CMAKE_INSTALL_PREFIX}/bin
)
