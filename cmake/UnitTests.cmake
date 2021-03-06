include(CTest)
enable_testing()

macro(UNITTEST prefix exec)
    set(target ${prefix}-${exec})
    add_executable(${target} EXCLUDE_FROM_ALL ${ARGN})
    add_dependencies(${prefix} ${target})
    set_target_properties(${target} PROPERTIES OUTPUT_NAME ${exec})
    target_link_libraries(${target} blitz ${BLITZ_EXTRA_LIBRARIES})
    if (WIN32)
        set(TEST_PATH ${EXECUTABLE_OUTPUT_PATH})
    else()
        set(TEST_PATH ${CMAKE_CURRENT_BINARY_DIR})
    endif()
    add_test(${exec} ${TEST_PATH}/${exec})
endmacro()

macro(TESTS prefix)
    foreach(example ${ARGN})
        UNITTEST(${prefix} ${example} ${example}.cpp)
    endforeach()
endmacro()

if (USE_GCC AND BUILD_TESTING)
    option(ENABLE_COVERAGE "Enable coverage" OFF)
    mark_as_advanced(ENABLE_COVERAGE)
endif()

if (ENABLE_COVERAGE)
    if (USE_GCC)
        set(COVERAGE_FLAGS "-fprofile-arcs -ftest-coverage")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${COVERAGE_FLAGS} -lgcov")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COVERAGE_FLAGS}")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COVERAGE_FLAGS}")
    else()
        message(SEND_ERROR "Coverage is only available with gcc.")
    endif()
endif()
