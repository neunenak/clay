cmake_minimum_required(VERSION 3.27)
project(clay_ffi_test C)

set(CMAKE_C_STANDARD 99)

add_executable(${PROJECT_NAME} main.c)

# Link against the Rust static library
target_link_libraries(${PROJECT_NAME} PRIVATE clay_rust)

# Include path for the Rust header
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}/rust/include
)

# On Linux, we need to link pthread and dl for Rust stdlib
if(UNIX AND NOT APPLE)
    target_link_libraries(${PROJECT_NAME} PRIVATE pthread dl m)
endif()

# On macOS, link System framework
if(APPLE)
    target_link_libraries(${PROJECT_NAME} PRIVATE "-framework Security")
endif()
