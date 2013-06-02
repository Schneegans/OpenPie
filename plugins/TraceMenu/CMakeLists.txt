# determine source and header files
file(GLOB_RECURSE PLUGIN_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.vala)

# use valac to compile sources to c files
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

GET_FILENAME_COMPONENT(_LIB_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

message("  Found plugin: " ${_LIB_NAME})

# compile c-sources
ADD_LIBRARY( ${_LIB_NAME} SHARED
    ${PLUGIN_SRC}
)

SET_TARGET_PROPERTIES(${_LIB_NAME} PROPERTIES LINKER_LANGUAGE C)
