################################################################
# Actually compile the executable
################################################################

# determine source and header files
file(GLOB VALA_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.vala */*.vala)

if (${INDICATOR_FOUND})
  LIST(APPEND DEFINES --define HAVE_APPINDICATOR)
endif(${INDICATOR_FOUND})
if (${INDICATOR3_FOUND})
  LIST(APPEND DEFINES --define HAVE_APPINDICATOR)
endif(${INDICATOR3_FOUND})

if (${GTK3_FOUND})
  LIST(APPEND DEFINES --define HAVE_GTK_3)
endif(${GTK3_FOUND})

if (${GMENU3_FOUND})
    LIST(APPEND DEFINES --define HAVE_GMENU_3)
endif (${GMENU3_FOUND})

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

