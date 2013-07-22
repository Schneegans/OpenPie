################################################################################
#                     Project OpenPie - Plugin library                         #
################################################################################

# Determine source files -------------------------------------------------------
file(GLOB_RECURSE PLUGIN_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.vala)

# Use valac to compile sources to c files --------------------------------------
vala_precompile(
    VALA_C
        ${PLUGIN_SRC}
    PACKAGES
        ${VALA_PKGS}
    CUSTOM_VAPIS
        ${OUTPUT_DIR}/lib/openpie/openpie.vapi
    OPTIONS
        --vapidir=${CMAKE_SOURCE_DIR}/third-party/vapi/
        --thread
        ${DEFINES}
)

# Get directory name and use it as plugin name ---------------------------------
get_filename_component(_LIB_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Set plugin output directory to it's source directory -------------------------
set(LIBRARY_OUTPUT_PATH ${OUTPUT_DIR}/share/openpie/plugins/)
message("  Found plugin: " ${_LIB_NAME})

# Compile c-sources ------------------------------------------------------------
add_library( ${_LIB_NAME} SHARED
    ${VALA_C}
)

set_target_properties(${_LIB_NAME} PROPERTIES LINKER_LANGUAGE C)
add_dependencies(${_LIB_NAME} openpie)
