cmake_minimum_required(VERSION 3.21)

project(LisPy LANGUAGES C)

set(C_STANDARD 99)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)

set(CMAKE_C_STANDARD ${C_STANDARD})
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(RUNTIME_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/bin" CACHE PATH "Directory for built LisPy executables")

file(MAKE_DIRECTORY "${RUNTIME_OUTPUT_DIR}")

option(LISPY_PYTHON "Enable Python FFI support" ON)

if(LISPY_PYTHON)
    find_package(Python3 COMPONENTS Interpreter Development QUIET)
    if(Python3_FOUND)
        message(STATUS "Python3 found: ${Python3_EXECUTABLE}")
        message(STATUS "  Include: ${Python3_INCLUDE_DIRS}")
        message(STATUS "  Libraries: ${Python3_LIBRARIES}")
        add_compile_definitions(LISPY_HAVE_PYTHON=1)
    else()
        message(STATUS "Python3 not found - building without Python support")
    endif()
endif()

add_executable(lispy lispy.c)

if(WIN32)
    target_sources(lispy PRIVATE lispy.rc)
endif()

if(LISPY_PYTHON)
    if(Python3_FOUND)
        target_include_directories(lispy PRIVATE ${Python3_INCLUDE_DIRS})
        target_link_libraries(lispy PRIVATE ${Python3_LIBRARIES})
    endif()
endif()

set_target_properties(lispy PROPERTIES
    C_STANDARD ${C_STANDARD}
    C_STANDARD_REQUIRED ON
    C_EXTENSIONS OFF
    RUNTIME_OUTPUT_DIRECTORY "${RUNTIME_OUTPUT_DIR}"
)
if(CMAKE_CONFIGURATION_TYPES)
    foreach(cfg ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER "${cfg}" cfg_upper)
        set_target_properties(lispy PROPERTIES
            "RUNTIME_OUTPUT_DIRECTORY_${cfg_upper}" "${RUNTIME_OUTPUT_DIR}"
        )
    endforeach()
endif()
if(NOT MSVC)
    target_link_libraries(lispy PRIVATE m)
endif()
if(WIN32)
    target_link_libraries(lispy PRIVATE advapi32)
endif()

install(TARGETS lispy RUNTIME DESTINATION bin)
install(FILES lispy.c DESTINATION src)

include(CheckCSourceCompiles)
include(CheckLanguage)