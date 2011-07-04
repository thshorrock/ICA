# - Try to find EnsembleLearning library
# Once done, this will define
#
#  EnsembleLearning_FOUND - system has EnsembleLearning
#  EnsembleLearning_INCLUDE_DIRS - the EnsembleLearning include directories
#  EnsembleLearning_LIBRARIES - link these to use EnsembleLearning

include(LibFindMacros)

# Dependencies
libfind_package(EnsembleLearning GSL)

# Use pkg-config to get hints about paths
libfind_pkg_check_modules(EnsembleLearning_PKGCONF EnsembleLearning)

# Include dir
find_path(EnsembleLearning_INCLUDE_DIR
  NAMES EnsembleLearning.hpp
  PATHS ${EnsembleLearning_PKGCONF_INCLUDE_DIRS} 
)

# Finally the library itself
find_library(EnsembleLearning_LIBRARY
  NAMES EnsembleLearning 
  PATHS ${EnsembleLearning_PKGCONF_LIBRARY_DIRS} 
)

# Set the include dir variables and the libraries and let libfind_process do the rest.
# NOTE: Singular variables for this library, plural for libraries this this lib depends on.
set(EnsembleLearning_PROCESS_INCLUDES EnsembleLearning_INCLUDE_DIR EnsembleLearning_INCLUDE_DIRS)
set(EnsembleLearning_PROCESS_LIBS EnsembleLearning_LIBRARY EnsembleLearning_LIBRARIES)
libfind_process(EnsembleLearning)