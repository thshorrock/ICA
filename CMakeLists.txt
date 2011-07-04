
cmake_minimum_required (VERSION 2.6)
project (EnsembleLearningProject)

# The version number.
set (EnsembleLearning_VERSION_MAJOR 0)
set (EnsembleLearning_VERSION_MINOR 1)
set (EnsembleLearning_PATCH_LEVEL 0 )

# project options
OPTION( BUILD_SHARED_LIBS "Set to OFF to build static libraries" ON )
OPTION( INSTALL_DOC "Set to OFF to skip build/install Documentation" ON )
OPTION( BUILD_EXAMPLES "Set to OFF to skip building the examples" ON )
OPTION( BUILD_MISSING_DEPENDANCIES "Set to OFF to skip building missing dependencies (you might want to build the latest versions yourself)" ON )
OPTION( BUILD_COVERAGE "Set to ON to generate coverage information (make lcov)" OFF )

# Put the libaries and binaries that get built into directories at the
# top of the build tree rather than in hard-to-find leaf
# directories.
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

#include find modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

##########################################################################
# MAKE SOME EXTRA BUILD TYPES:
#  MAINTAINER: with some extra warnings (only gcc)
#  PROFILE:  Profiling mode (only gcc)
###########################################################################
##########################################################################
#  MAINTAINTER
##########################################################################

IF (CMAKE_COMPILER_IS_GNUCC)
SET( CMAKE_CXX_FLAGS_MAINTAINER "-Wall -Wabi" CACHE STRING
    "Flags used by the C++ compiler during maintainer builds."
    FORCE )
SET( CMAKE_C_FLAGS_MAINTAINER "-Wall -pedantic" CACHE STRING
    "Flags used by the C compiler during maintainer builds."
    FORCE )
SET( CMAKE_EXE_LINKER_FLAGS_MAINTAINER
    "-Wl,--warn-unresolved-symbols,--warn-once" CACHE STRING
    "Flags used for linking binaries during maintainer builds."
    FORCE )
SET( CMAKE_SHARED_LINKER_FLAGS_MAINTAINER
    "-Wl,--warn-unresolved-symbols,--warn-once" CACHE STRING
    "Flags used by the shared libraries linker during maintainer builds."
    FORCE )
MARK_AS_ADVANCED(
    CMAKE_CXX_FLAGS_MAINTAINER
    CMAKE_C_FLAGS_MAINTAINER
    CMAKE_EXE_LINKER_FLAGS_MAINTAINER
    CMAKE_SHARED_LINKER_FLAGS_MAINTAINER )
# Update the documentation string of CMAKE_BUILD_TYPE for GUIs
SET( CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING
    "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel Maintainer."
    FORCE )
ENDIF()
##########################################################################
#  PROFILE
##########################################################################

IF (CMAKE_COMPILER_IS_GNUCC)
SET( CMAKE_CXX_FLAGS_PROFILE "-O2 -g -pg" CACHE STRING
    "Flags used by the C++ compiler during profile builds."
    FORCE )
SET( CMAKE_C_FLAGS_PROFILE "-O2 -g -pg" CACHE STRING
    "Flags used by the C compiler during profile builds."
    FORCE )
SET( CMAKE_EXE_LINKER_FLAGS_PROFILE
    "-pg " CACHE STRING #-static-libgcc -lc_p
    "Flags used for linking binaries during profile builds."
    FORCE )
SET( CMAKE_SHARED_LINKER_FLAGS_PROFILE
    "-pg  " CACHE STRING #-static-libgcc -lc_p
    "Flags used by the shared libraries linker during profile builds."
    FORCE )
MARK_AS_ADVANCED(
    CMAKE_CXX_FLAGS_PROFILE
    CMAKE_C_FLAGS_PROFILE
    CMAKE_EXE_LINKER_FLAGS_PROFILE
    CMAKE_SHARED_LINKER_FLAGS_PROFILE )
# Update the documentation string of CMAKE_BUILD_TYPE for GUIs
SET( CMAKE_BUILD_TYPE "${CMAKE_BUILD_TYPE}" CACHE STRING
    "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel  Maintainer Profile."
    FORCE )
ENDIF()


##########################################################################
# Check for architecture and sse extentions
##########################################################################
include(cmake/architecture.cmake)
include(cmake/sse.cmake)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SSE_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${MARCH_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SSE_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${MARCH_FLAGS}")


##########################################################################
# Add OpenMP support
##########################################################################

#require the omp library
FIND_PACKAGE(OpenMP REQUIRED) 
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_C_FLAGS}")


##########################################################################
# The libraries and executables depend upon boost and gsl library.
# If these already exist on system then want to use the existing install.
#  If not (and if BUILD_MISSING_DEPENDANCIES is ON) then want to build them.
###########################################################################

##########################################################################
#  BOOST FIRST;
##########################################################################
FIND_PACKAGE(Boost COMPONENTS system program_options test_exec_monitor filesystem REQUIRED) # do we have any boost at all?

IF(Boost_FOUND)
  include_directories(${Boost_INCLUDE_DIRS})
ENDIF()

##########################################################################
#  Now gsl subset
##########################################################################
set(GSL_DIR cmake)
find_package(GSL REQUIRED)
IF(GSL_FOUND)
  include_directories(${GSL_INCLUDE_DIRS} ${GSLCBLAS_INCLUDE_DIRS})
ENDIF(GSL_FOUND)

##########################################################################
# Ensemble Learning modules               
# Do in the same style as Boost.CMake so that uniform style if libraries not found      #
##########################################################################

#include(boost/tools/build/CMake/BoostUtils.cmake)
#message(STATUS "./cmake")
#colormsg(_HIBLUE_ "Ensemble Learning Project, starting ...")
#message(STATUS "")

##########################################################################
#  Find the EL library 
##########################################################################

find_package(EnsembleLearning REQUIRED)
IF(EnsembleLearning_FOUND)
  include_directories(${EnsembleLearning_INCLUDE_DIRS} ${GSLCBLAS_INCLUDE_DIRS})
ENDIF(EnsembleLearning_FOUND )
message("lib = ${EnsembleLearning_LIBRARIES}")
##########################################################################
#  Build the app
##########################################################################

add_subdirectory(ICA-src/build)

##########################################################################
#  Packaging
##########################################################################


INCLUDE(InstallRequiredSystemLibraries)

SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Ensemble Learning Project")
SET(CPACK_PACKAGE_VENDOR "T.H. Shorrock")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.txt")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE_1_0.txt")
SET(CPACK_PACKAGE_VERSION_MAJOR "0")
SET(CPACK_PACKAGE_VERSION_MINOR "1")
SET(CPACK_PACKAGE_VERSION_PATCH "0")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "CMake ${CMake_VERSION_MAJOR}.${CMake_VERSION_MINOR}")
IF(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
  #SET(CPACK_PACKAGE_ICON "${CMake_SOURCE_DIR}/Utilities/Release\\\\InstallIcon.bmp")
  SET(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\ICA.exe")
  SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY} EnsembleLearning")
  SET(CPACK_NSIS_HELP_LINK "http:\\\\\\\\git@github.com:thshorrock/Ensemble-Learning.git")
  #SET(CPACK_NSIS_URL_INFO_ABOUT "http:\\\\\\\\www.my-personal-home-page.com")
  SET(CPACK_NSIS_CONTACT "t.h.shorrock@gmail.com")
  SET(CPACK_NSIS_MODIFY_PATH ON)
ELSE(WIN32 AND NOT UNIX)
  SET(CPACK_STRIP_FILES "bin/ICA")
  SET(CPACK_SOURCE_STRIP_FILES "")
ENDIF(WIN32 AND NOT UNIX)
SET(CPACK_PACKAGE_EXECUTABLES "ICA" "EnsembleLearning")
INCLUDE(CPack)