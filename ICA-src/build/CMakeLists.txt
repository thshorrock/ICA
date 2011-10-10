## Make the ICA-noise example project
project (ICA-noise)



#require the omp library
FIND_PACKAGE(OpenMP REQUIRED) 
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_C_FLAGS}")

#include EL library
include_directories ("${EnsembleLearning_INCLUDE_DIRS}")
#include the includes of this project
include_directories ("${ICA-noise_SOURCE_DIR}/../include")

#build
add_executable(ICA-noise  ../src/ICA.cpp)
target_link_libraries (ICA-noise ${Boost_LIBRARIES})
target_link_libraries (ICA-noise ${boost_numeric_LIBRARY} ${GSL_LIBRARIES} ${boost_filesystem_LIBRARY} ${boost_program_options_LIBRARY} ${boost_system_LIBRARY} ${EnsembleLearning_LIBRARIES} )

install (TARGETS ICA-noise DESTINATION bin)