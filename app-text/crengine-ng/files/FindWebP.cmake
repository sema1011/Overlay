# FindWebP.cmake - Find the WebP library
# This module defines:
#  WebP_FOUND - System has WebP
#  WebP_INCLUDE_DIRS - WebP include directories
#  WebP_LIBRARIES - Libraries needed to use WebP

find_path(WebP_INCLUDE_DIR
    NAMES webp/decode.h
    PATHS /usr/include /usr/local/include
)

find_library(WebP_LIBRARY
    NAMES webp
    PATHS /usr/lib /usr/local/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(WebP
    REQUIRED_VARS WebP_LIBRARY WebP_INCLUDE_DIR
)

if(WebP_FOUND)
    set(WebP_INCLUDE_DIRS ${WebP_INCLUDE_DIR})
    set(WebP_LIBRARIES ${WebP_LIBRARY})
endif()

mark_as_advanced(WebP_INCLUDE_DIR WebP_LIBRARY)
