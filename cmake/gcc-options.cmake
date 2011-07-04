
#if( CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX )
#  set(MARCH_FLAGS)  
#  set(MARCH_FLAGS "-march=native") #let gcc work it out
#end()