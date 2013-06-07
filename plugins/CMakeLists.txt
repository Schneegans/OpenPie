################################################################################
#                     Project OpenPie - Menu plugins                           #
################################################################################

message( "" )
message( "Searching for plugins..." )

file(GLOB _PLUGINS ${CMAKE_SOURCE_DIR}/plugins/*)

FOREACH(_PLUGIN ${_PLUGINS})
  IF (EXISTS ${_PLUGIN}/CMakeLists.txt)
    add_subdirectory(${_PLUGIN})
  ENDIF()
ENDFOREACH(_PLUGIN ${_PLUGINS})
