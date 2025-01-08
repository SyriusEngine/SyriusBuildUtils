include(FetchContent)

include(${CMAKE_CURRENT_LIST_DIR}/CMakeColoredText.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/CMakeCompilerFlags.cmake)

set (CMAKE_CXX_STANDARD 17)

function(INCLUDE_OR_FETCH LIB_NAME OUTPUT_LIB_ROOT)
    if (NOT TARGET ${LIB_NAME})
        message(STATUS "Including ${LIB_NAME}")
        # Assume the local version is in a child folder and that the name of the library is the same as the folder name
        set(LIB_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../${LIB_NAME})

        # Locally available?
        if (EXISTS ${LIB_ROOT})
            message(STATUS "Using local version of ${LIB_NAME}")
            add_subdirectory(${LIB_ROOT} ${CMAKE_BINARY_DIR}/${LIB_NAME})

        else()
            message(STATUS "Cloning ${LIB_NAME} from git (main branch)")
            FetchContent_Declare(
                ${LIB_NAME}
                GIT_REPOSITORY https://github.com/SyriusEngine/${LIB_NAME}.git
                GIT_SHALLOW TRUE
                GIT_PROGRESS TRUE
            )
            FetchContent_MakeAvailable(${LIB_ROOT})
        endif()
        set(${OUTPUT_LIB_ROOT} ${LIB_ROOT} PARENT_SCOPE)
    else()
        message(WARNING "No target ${LIB_NAME} found!")
    endif()
endfunction()

