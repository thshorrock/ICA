## Make the ICA example project
project (ICA)



#require the omp library
FIND_PACKAGE(OpenMP REQUIRED) 
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_C_FLAGS}")

#include EL library
include_directories ("${EnsembleLearning_INCLUDE_DIRS}")
#include the includes of this project
include_directories ("${ICA_SOURCE_DIR}/../include")

#build
add_executable(ICA  ../src/ICA.cpp)
target_link_libraries (ICA ${Boost_LIBRARIES})
target_link_libraries (ICA ${boost_numeric_LIBRARY} ${GSL_LIBRARIES} ${boost_filesystem_LIBRARY} ${boost_program_options_LIBRARY} ${boost_system_LIBRARY} ${EnsembleLearning_LIBRARIES} )

install (TARGETS ICA DESTINATION bin)