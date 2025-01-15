include(FetchContent)

function(fetch_gtest)
    if (NOT TARGET gtest)
        message(STATUS "Fetching GTest")
        FetchContent_Declare(
            googletest
            GIT_REPOSITORY https://github.com/google/googletest.git
            GIT_TAG main
            GIT_PROGRESS TRUE # Show progress
            GIT_SHALLOW TRUE # Only fetch the latest commit
        )
        FetchContent_MakeAvailable(googletest)
    else()
        message(WARNING "No target gtest found!")
    endif()
endfunction()

function(fetch_glfw)
    if (NOT TARGET glfw)
        message(STATUS "Fetching GLFW")
        FetchContent_Declare(
            glfw
            GIT_REPOSITORY https://github.com/glfw/glfw.git
            GIT_TAG master
            GIT_PROGRESS TRUE # Show progress
            GIT_SHALLOW TRUE
        )
        FetchContent_MakeAvailable(glfw)
    else()
        message(WARNING "No target glfw found!")
    endif()
endfunction()