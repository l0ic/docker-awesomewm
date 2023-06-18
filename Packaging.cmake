if(NOT VERSION)
    set(VERSION "unknown")
endif()

string(REGEX REPLACE "^v?([0-9.]+)-?(.*)$"
    "\\1;\\2" version_result ${VERSION})

list(LENGTH version_result version_result_list_length)

if(version_result_list_length EQUAL 2)
    list(GET version_result 0 version_num)
    list(GET version_result 1 version_gitstamp)
else(version_result_list_length EQUAL 2)
    message("Unable to deduce a meaningful version number. \
Set OVERRIDE_VERSION when you run CMake (cmake .. -DOVERRIDE_VERSION=3.14.159), or \
just build from a git repository.")
    set(version_num "0.0.0")
    set(version_gitstamp "")
endif(version_result_list_length EQUAL 2)

if(version_gitstamp)
    set(version_gitsuffix "~git${version_gitstamp}")
else(version_gitstamp)
    set(version_gitsuffix "")
endif(version_gitstamp)

string(REGEX REPLACE "([0-9]+)\\.([0-9]+)\\.([0-9]+)"
    "\\1;\\2;\\3" version_num_split ${version_num})

list(APPEND version_num_split 0 0 0) #ensure the list(GET )) commands below never fail

list(GET version_num_split 0 CPACK_PACKAGE_VERSION_MAJOR)
list(GET version_num_split 1 CPACK_PACKAGE_VERSION_MINOR)
list(GET version_num_split 2 CPACK_PACKAGE_VERSION_PATCH)

set(version_num "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

if(NOT DEFINED CPACK_GENERATOR)
    set(CPACK_GENERATOR)
    message(STATUS "Checking if 'package' target should be generated.")
    a_find_program(rpmbuild_path "rpmbuild" FALSE)
    if(rpmbuild_path)
        message(STATUS "rpmbuild found, enabling RPM for the 'package' target.")
        list(APPEND CPACK_GENERATOR RPM)
    else(rpmbuild_path)
        message(STATUS "The 'package' target will not build a RPM.")
    endif(rpmbuild_path)

    a_find_program(dpkg_path "dpkg" FALSE)
    if (dpkg_path)
        message(STATUS "dpkg found, enabling DEB for the 'package' target.")
        list(APPEND CPACK_GENERATOR DEB)
    else(dpkg_path)
        message(STATUS "The 'package' target will not build a DEB.")
    endif(dpkg_path)

    if(NOT CPACK_GENERATOR)
        message(STATUS "Skipping generation of 'package' target.")
    endif()
endif(NOT DEFINED CPACK_GENERATOR)
set(CPACK_GENERATOR ${CPACK_GENERATOR}
    CACHE STRING "Include CPack if non-empty (DEB and/or RPM).")

if(CPACK_GENERATOR)
    message(STATUS "Package version will be set to ${version_num}${version_gitsuffix}.")
    set(CPACK_PACKAGE_VERSION "${version_num}${version_gitsuffix}")
    set(CPACK_PACKAGE_NAME "awesome")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "devnull@example.com")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "A tiling window manager")
    set(CPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST_ADDITION "/etc/xdg;/usr/share/xsessions")

    set (CPACK_DEBIAN_PACKAGE_DEPENDS "default-dbus-session-bus | dbus-session-bus, gir1.2-freedesktop, gir1.2-gdkpixbuf-2.0, gir1.2-glib-2.0, gir1.2-pango-1.0, libcairo-gobject2, lua-lgi (>= 0.9.2), menu, libc6 (>= 2.34), libcairo2 (>= 1.12.0), libdbus-1-3 (>= 1.9.14), libgdk-pixbuf-2.0-0 (>= 2.22.0), libglib2.0-0 (>= 2.30.0), liblua5.3-0, libstartup-notification0 (>= 0.10), libx11-6, libxcb-cursor0 (>= 0.0.99), libxcb-icccm4 (>= 0.4.1), libxcb-keysyms1 (>= 0.4.0), libxcb-randr0 (>= 1.12), libxcb-shape0, libxcb-util1 (>= 0.4.0), libxcb-xinerama0, libxcb-xkb1, libxcb-xrm0 (>= 0.0.0), libxcb-xtest0, libxcb1 (>= 1.6), libxdg-basedir1, libxkbcommon-x11-0 (>= 0.5.0), libxkbcommon0 (>= 0.5.0)")
    set (CPACK_DEBIAN_PACKAGE_RECOMMENDS "feh, rlwrap, x11-xserver-utils, awesome-extra, gir1.2-gtk-3.0")
    set (CPACK_DEBIAN_PACKAGE_SUGGESTS "awesome-doc")
    include(CPack)
endif()

# vim: filetype=cmake:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80:foldmethod=marker
