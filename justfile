# Clay UI Library - Justfile
_default:
    @just --list

# Run all tests (Docker-based build tests with gcc 9.4)
[group: "test"]
test:
    cd tests && ./run-tests.sh

# Run tests with docker compose directly
[group: "test"]
test-docker:
    cd tests && docker compose build && docker compose up

# Clean docker test artifacts
[group: "test"]
test-clean:
    cd tests && docker compose down -v

# Build project locally with CMake
[group: "build"]
build:
    cmake -B build -S .
    cmake --build build

# Build with all examples enabled
[group: "build"]
build-all:
    cmake -B build -S . -DCLAY_INCLUDE_ALL_EXAMPLES=ON
    cmake --build build

# Build with specific example categories
[group: "build"]
build-raylib:
    cmake -B build -S . -DCLAY_INCLUDE_RAYLIB_EXAMPLES=ON
    cmake --build build

[group: "build"]
build-sdl2:
    cmake -B build -S . -DCLAY_INCLUDE_SDL2_EXAMPLES=ON
    cmake --build build

[group: "build"]
build-sdl3:
    cmake -B build -S . -DCLAY_INCLUDE_SDL3_EXAMPLES=ON
    cmake --build build

[group: "build"]
build-sokol:
    cmake -B build -S . -DCLAY_INCLUDE_SOKOL_EXAMPLES=ON
    cmake --build build

[group: "build"]
build-demos:
    cmake -B build -S . -DCLAY_INCLUDE_DEMOS=ON
    cmake --build build

# Clean build artifacts
[group: "clean"]
clean:
    rm -rf build

# Full clean including docker test artifacts
[group: "clean"]
clean-all: clean test-clean

# Configure project with CMake
[group: "configure"]
configure:
    cmake -B build -S .

# Reconfigure from scratch
[group: "configure"]
reconfigure: clean configure
