################################################################################
#                     Project OpenPie - Shared library                         #
################################################################################

# Determine source files -------------------------------------------------------
file(GLOB VALA_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.vala */*.vala)

# Use valac to compile sources to c files --------------------------------------
vala_precompile(
    VALA_C
        ${VALA_SRC}
    PACKAGES
        ${VALA_PKGS}
    OPTIONS
        --vapidir=${CMAKE_SOURCE_DIR}/vapi/
        --thread
        ${DEFINES}
        -H ${OUTPUT_DIR}/include/openpie/openpie.h
    GENERATE_VAPI
        ${OUTPUT_DIR}/lib/openpie/openpie
)

# Compile c-sources ------------------------------------------------------------
set(LIBRARY_OUTPUT_PATH ${OUTPUT_DIR}/lib/openpie/)
ADD_LIBRARY( openpie SHARED
    ${VALA_C}
)

SET_TARGET_PROPERTIES(openpie PROPERTIES LINKER_LANGUAGE C)

# Install library --------------------------------------------------------------
install(
	TARGETS
		openpie
	LIBRARY DESTINATION
		${CMAKE_INSTALL_PREFIX}/bin
)

