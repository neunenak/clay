/*
 * Clay Rust FFI Header
 *
 * This header declares functions implemented in Rust and linked
 * as a static library. Include this header in C code that needs
 * to call Rust functions.
 */

#ifndef CLAY_RUST_H
#define CLAY_RUST_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Add two integers.
 * Proof of concept FFI function implemented in Rust.
 *
 * @param a First operand
 * @param b Second operand
 * @return Sum of a and b (wrapping on overflow)
 */
int32_t clay_rust_add(int32_t a, int32_t b);

/**
 * Get the Rust library version.
 *
 * @return Version number (currently 1 for v0.1)
 */
int32_t clay_rust_version(void);

#ifdef __cplusplus
}
#endif

#endif /* CLAY_RUST_H */
