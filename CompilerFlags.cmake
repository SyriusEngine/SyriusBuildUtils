# print C and C++ compiler
include(PrettyColors.cmake)

message(STATUS "${Yellow}C Compiler: ${CMAKE_C_COMPILER}${ColorReset}")
message(STATUS "${Yellow}C++ Compiler: ${CMAKE_CXX_COMPILER}${ColorReset}")
message(STATUS "${Yellow}Linker: ${CMAKE_LINKER}${ColorReset}")
message(STATUS "${Yellow}CMake Generator: ${CMAKE_GENERATOR}${ColorReset}")

# Set C++ version to 23
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
message(STATUS "${Yellow}C++ Version: ${CMAKE_CXX_STANDARD}${ColorReset}")

# Configure ccache (if found)
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    message(STATUS "${Green}Found ccache: ${CCACHE_PROGRAM}${ColorReset}")
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE_PROGRAM})
else()
    message(STATUS "ccache not found; not using a compiler launcher.")
endif()

# check build type
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "${Green}Building in Debug Mode${ColorReset}")
    add_compile_definitions(SR_DEBUG)
else()
    message(STATUS "Building in Release Mode")
endif()

# Compiler specific flags
if (MSVC)
    # Flag for recursive macro expansion
    add_compile_options(/Zc:preprocessor)
endif ()

# https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html
# Sanitizers are only used for test executables
# Sadly MinGW has no sanitizer flags
if (BUILD_TESTS AND NOT NO_SANITIZER AND NOT MINGW)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        add_compile_options(-fno-omit-frame-pointer -g)
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        add_compile_options(-fno-omit-frame-pointer)
    endif()

    # ADDRESS_SANITIZER: Stops execution if a memory leak, use after free
    # or buffer overflow is detected
    if (NOT NO_ADDRESS_SANITIZER)
        message(STATUS "Enabling address sanitizer")
        # TODO: There is also an experimental flag -fsanitize=hwaddress
        # which uses the hardware memory protection features of the CPU,
        # but it is currently only supported on aarch64.
        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            add_compile_options(-fsanitize=address -static-libasan)
            add_link_options(-fsanitize=address)
        elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
            add_compile_options(-fsanitize=address -fsanitize-address-use-after-scope)
            add_link_options(-fsanitize=address)
        else()
            message(WARNING "No address sanitizer for ${CMAKE_CXX_COMPILER_ID}")
        endif()
    endif()

    # UB_SANITIZER: Stops execution if undefined behavior is detected
    if (NOT NO_UB_SANITIZER)
        message(STATUS "Enabling UB sanitizer")
        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            add_compile_options(-fsanitize=undefined)
            add_link_options(-fsanitize=undefined)
        elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
            add_compile_options(-fsanitize=undefined)
            add_link_options(-fsanitize=undefined)
        else()
            message(WARNING "No UB sanitizer for ${CMAKE_CXX_COMPILER_ID}")
        endif()
    endif()
else ()
    message(STATUS "Sanitizers disabled")
    if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        add_compile_options(-fno-sanitize=all)
        add_link_options(-fno-sanitize=all)
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        add_compile_options(-fno-sanitize=all)
        add_link_options(-fno-sanitize=all)
    endif()
endif()
