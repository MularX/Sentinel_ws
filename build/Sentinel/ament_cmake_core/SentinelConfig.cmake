# generated from ament/cmake/core/templates/nameConfig.cmake.in

# prevent multiple inclusion
if(_Sentinel_CONFIG_INCLUDED)
  # ensure to keep the found flag the same
  if(NOT DEFINED Sentinel_FOUND)
    # explicitly set it to FALSE, otherwise CMake will set it to TRUE
    set(Sentinel_FOUND FALSE)
  elseif(NOT Sentinel_FOUND)
    # use separate condition to avoid uninitialized variable warning
    set(Sentinel_FOUND FALSE)
  endif()
  return()
endif()
set(_Sentinel_CONFIG_INCLUDED TRUE)

# output package information
if(NOT Sentinel_FIND_QUIETLY)
  message(STATUS "Found Sentinel: 1.0.0 (${Sentinel_DIR})")
endif()

# warn when using a deprecated package
if(NOT "" STREQUAL "")
  set(_msg "Package 'Sentinel' is deprecated")
  # append custom deprecation text if available
  if(NOT "" STREQUAL "TRUE")
    set(_msg "${_msg} ()")
  endif()
  # optionally quiet the deprecation message
  if(NOT ${Sentinel_DEPRECATED_QUIET})
    message(DEPRECATION "${_msg}")
  endif()
endif()

# flag package as ament-based to distinguish it after being find_package()-ed
set(Sentinel_FOUND_AMENT_PACKAGE TRUE)

# include all config extra files
set(_extras "")
foreach(_extra ${_extras})
  include("${Sentinel_DIR}/${_extra}")
endforeach()
