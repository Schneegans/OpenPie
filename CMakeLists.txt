################################################################################
#                 Project OpenPie - Main CMakeLists file                       #
################################################################################

project("openpie" C)


# Initialize CMake -------------------------------------------------------------
cmake_minimum_required(VERSION 2.6)

# Location where cmake first looks for modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/third-party/cmake)


# Find Vala --------------------------------------------------------------------
include(ValaPrecompile)
include(ValaVersion)

find_package(Vala)
ensure_vala_version("0.11.0" MINIMUM)

set(OUTPUT_DIR ${CMAKE_SOURCE_DIR}/build/output)


# Configure and find libraries -------------------------------------------------
find_package(PkgConfig)

pkg_check_modules(GTK3 REQUIRED gtk+-3.0)
pkg_check_modules(UNIQUE REQUIRED unique-3.0)
pkg_check_modules(GIO REQUIRED gio-unix-2.0)
pkg_check_modules(CAIRO REQUIRED cairo)
pkg_check_modules(GEE REQUIRED gee-1.0)
pkg_check_modules(X11 REQUIRED x11)
pkg_check_modules(XML REQUIRED libxml-2.0)
pkg_check_modules(XTST REQUIRED xtst)
pkg_check_modules(CLUTTER REQUIRED clutter-gtk-1.0)
pkg_check_modules(JSON json-glib-1.0)
pkg_check_modules(MODULE gmodule-2.0)

find_library(M_LIB m)
find_library(GTHREAD_LIB gthread-2.0)

set(CFLAGS
  ${GIO_CFLAGS}
  ${GTK3_CFLAGS} ${GTK3_CFLAGS_OTHER}
  ${CAIRO_CFLAGS} ${CAIRO_CFLAGS_OTHER}
  ${GEE_CFLAGS} ${CAIRO_CFLAGS_OTHER}
  ${X11_CFLAGS} ${X11_CFLAGS_OTHER}
	-DGMENU_I_KNOW_THIS_IS_UNSTABLE
	-DWNCK_I_KNOW_THIS_IS_UNSTABLE
  -DGETTEXT_PACKAGE="openpie"
	-s -O3 -w
#	-g
)

add_definitions(${CFLAGS})

set(LIBS
  ${GIO_LIBRARIES}
	${GTK3_LIBRARIES}
	${CAIRO_LIBRARIES}
	${GEE_LIBRARIES}
	${XML_LIBRARIES}
	${XTST_LIBRARIES}
	${UNIQUE_LIBRARIES}
	${X11_LIBRARIES}
  ${CLUTTER_LIBRARIES}
	${M_LIB}
	${GTHREAD_LIB}
	${JSON_LIBRARIES}
	${MODULE_LIBRARIES}
)
link_libraries(${LIBS})

set(LIB_PATHS
  ${GIO_LIBRARY_DIRS}
	${GTK3_LIBRARY_DIRS}
	${CAIRO_LIBRARY_DIRS}
	${GEE_LIBRARY_DIRS}
	${XML_LIBRARY_DIRS}
	${XTST_LIBRARY_DIRS}
  ${CLUTTER_LIBRARY_DIRS}
	${UNIQUE_LIBRARY_DIRS}
	${X11_LIBRARY_DIRS}
	${JSON_LIBRARY_DIRS}
	${MODULE_LIBRARY_DIRS}
	${OUTPUT_DIR}/lib/
)
link_directories(${LIB_PATHS})

set(INCLUDE_PATHS
  ${GIO_INCLUDE_DIRS}
	${GTK3_INCLUDE_DIRS}
	${CAIRO_INCLUDE_DIRS}
	${GEE_INCLUDE_DIRS}
	${XML_INCLUDE_DIRS}
  ${CLUTTER_INCLUDE_DIRS}
	${XTST_INCLUDE_DIRS}
	${UNIQUE_INCLUDE_DIRS}
	${X11_INCLUDE_DIRS}
	${JSON_INCLUDE_DIRS}
	${MODULE_INCLUDE_DIRS}
	${OUTPUT_DIR}/include/openpie/
)
include_directories(${INCLUDE_PATHS})

set(VALA_PKGS
  gtk+-3.0
  unique-3.0
  gdk-x11-3.0
  cairo
  gee-1.0
  x11
  gio-unix-2.0
  posix
  libxml-2.0
  xtst
  json-glib-1.0
  clutter-gtk-1.0
  gmodule-2.0
)


# Add shared library -----------------------------------------------------------
add_subdirectory(lib)


# Add daemon executable --------------------------------------------------------
add_subdirectory(daemon)


# Add plugins ------------------------------------------------------------------
add_subdirectory(plugins)


# Add uninstall option ---------------------------------------------------------
configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/CMake_Uninstall.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/CMake_Uninstall.cmake"
  IMMEDIATE @ONLY)

add_custom_target(uninstall
  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/CMake_Uninstall.cmake)


# Print summary ----------------------------------------------------------------
message( "" )
message( "Summary:" )
message( "  VALA_EXECUTABLE = ${VALA_EXECUTABLE}" )
message( "Libs:" )
message( "  GTK3_LIBRARIES = ${GTK3_LIBRARIES}" )
message( "  CAIRO_LIBRARIES = ${CAIRO_LIBRARIES}" )
message( "  GEE_LIBRARIES = ${GEE_LIBRARIES}" )
message( "  XML_LIBRARIES = ${XML_LIBRARIES}" )
message( "  XTST_LIBRARIES = ${XTST_LIBRARIES}" )
message( "  UNIQUE_LIBRARIES = ${UNIQUE_LIBRARIES}" )
message( "  X11_LIBRARIES = ${X11_LIBRARIES}" )
message( "  CLUTTER_LIBRARIES = ${CLUTTER_LIBRARIES}" )
message( "  MODULE_LIBRARIES = ${MODULE_LIBRARIES}" )
message( "" )


