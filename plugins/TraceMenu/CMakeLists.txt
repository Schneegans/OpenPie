################################################################################
#                     Project OpenPie - Plugin library                         #
################################################################################

# Determine source files -------------------------------------------------------
file(GLOB_RECURSE PLUGIN_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.vala ../../src/plugins/PluginInterface.vala)

# Use valac to compile sources to c files --------------------------------------
vala_precompile(
    VALA_C
        ${PLUGIN_SRC}
    PACKAGES
        ${VALA_PKGS}
    OPTIONS
        --vapidir=${CMAKE_SOURCE_DIR}/vapi/
        --thread
        ${DEFINES}
)

# Get directory name and use it as plugin name ---------------------------------
GET_FILENAME_COMPONENT(_LIB_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Set plugin output directory to it's source directory -------------------------
set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
message("  Found plugin: " ${_LIB_NAME})

# Compile c-sources ------------------------------------------------------------
ADD_LIBRARY( ${_LIB_NAME} SHARED
    ${VALA_C}
)

SET_TARGET_PROPERTIES(${_LIB_NAME} PROPERTIES LINKER_LANGUAGE C)
