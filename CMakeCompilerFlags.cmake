# print C and C++ compiler
message(STATUS "C Compiler: ${CMAKE_C_COMPILER_ID}")
message(STATUS "C++ Compiler: ${CMAKE_CXX_COMPILER_ID}")

# check build type
if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "Building in Debug Mode")
    add_compile_definitions(SR_DEBUG)
else()
    message(STATUS "Building in Release Mode")
endif()

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
            add_compile_options(-fsanitize=address -fsanitize=memory -fsanitize-address-use-after-scope)
            add_link_options(-fsanitize=address -fsanitize=memory)
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
