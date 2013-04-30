################################################################
# Actually compile the executable
################################################################

# determine source and header files
file(GLOB VALA_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.vala */*.vala)

# use valac to compile sources to c files
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

# compile c-sources
add_executable(openpie ${VALA_C})

# install executable
install(
	TARGETS
		openpie
	RUNTIME DESTINATION
		${CMAKE_INSTALL_PREFIX}/bin
)

# install credits
install(
	FILES
		${CMAKE_SOURCE_DIR}/README.md
	DESTINATION
		${CMAKE_INSTALL_PREFIX}/share/doc/openpie
)

# install locales
install(
	DIRECTORY
		${CMAKE_SOURCE_DIR}/resources/locale
	DESTINATION
		${CMAKE_INSTALL_PREFIX}/share
	PATTERN *.po EXCLUDE
	PATTERN *.pot EXCLUDE
	PATTERN *.sh EXCLUDE
)

# install themes
install(
	DIRECTORY
		${CMAKE_SOURCE_DIR}/resources/themes
	DESTINATION
		${CMAKE_INSTALL_PREFIX}/share/openpie
)

# install manpage
install(
	FILES
		${CMAKE_SOURCE_DIR}/resources/openpie.1
	DESTINATION
		${CMAKE_INSTALL_PREFIX}/share/man/man1
)

