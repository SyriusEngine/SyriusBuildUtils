include(FetchContent)

function(fetch_lib target_name url git_tag)
    if (NOT TARGET ${target_name})
        message(STATUS "Fetching ${target_name}")
        FetchContent_Declare(
            ${target_name}
            GIT_REPOSITORY ${url}
            GIT_TAG ${git_tag}
            GIT_PROGRESS TRUE # Show progress
            GIT_SHALLOW TRUE # Only fetch the latest commit
        )
        FetchContent_MakeAvailable(${target_name})
    else()
        message(WARNING "No target ${target_name} found!")
    endif ()
endfunction()

function(fetch_gtest)
    fetch_lib(gtest https://github.com/google/googletest.git main)
endfunction()

function(fetch_glfw)
    fetch_lib(glfw https://github.com/glfw/glfw.git master)
endfunction()

function(fetch_glm)
    fetch_lib(glm https://github.com/g-truc/glm.git bf71a834948186f4097caa076cd2663c69a10e1e)
endfunction()

function(fetch_fmt)
    fetch_lib(fmt https://github.com/fmtlib/fmt.git master)
endfunction()

function(fetch_spdlog)
    fetch_lib(spdlog git@github.com:gabime/spdlog.git master)
endfunction()