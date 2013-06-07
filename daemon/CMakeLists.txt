################################################################################
#                  Project OpenPie - Daemon executable                         #
################################################################################

# Determine source files -------------------------------------------------------
file(GLOB VALA_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.vala */*.vala)

# Use valac to compile sources to c files --------------------------------------
vala_precompile(
    VALA_C
        ${VALA_SRC}
    PACKAGES
        ${VALA_PKGS}
    CUSTOM_VAPIS
        ${OUTPUT_DIR}/lib/openpie/openpie.vapi
    OPTIONS
        --vapidir=${CMAKE_SOURCE_DIR}/third-party/vapi/
        --thread
        ${DEFINES}
)

# Compile c-sources ------------------------------------------------------------
set(EXECUTABLE_OUTPUT_PATH ${OUTPUT_DIR}/bin/)
add_executable(openpie-daemon ${VALA_C})
target_link_libraries(openpie-daemon openpie)

# Install executable -----------------------------------------------------------
install(
	TARGETS
		openpie-daemon
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


