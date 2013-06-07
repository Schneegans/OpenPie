################################################################################
#                    Project OpenPie - Main executable                         #
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
)

# Compile c-sources ------------------------------------------------------------
add_executable(openpie ${VALA_C})

# Install executable -----------------------------------------------------------
install(
	TARGETS
		openpie
	RUNTIME DESTINATION
		${CMAKE_INSTALL_PREFIX}/bin
)

# Install credits --------------------------------------------------------------
install(
	FILES
		${CMAKE_SOURCE_DIR}/README.md
	DESTINATION
		${CMAKE_INSTALL_PREFIX}/share/doc/openpie
)


