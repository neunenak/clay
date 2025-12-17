/*
 * Clay Rust FFI Test
 *
 * This test verifies that the Rust static library is correctly
 * linked and callable from C code.
 */

#include <stdio.h>
#include <stdlib.h>
#include "clay_rust.h"

#define TEST_ASSERT(cond, msg) do { \
    if (!(cond)) { \
        fprintf(stderr, "FAILED: %s\n", msg); \
        return 1; \
    } \
    printf("PASSED: %s\n", msg); \
} while(0)

int main(void) {
    printf("=== Clay Rust FFI Test ===\n\n");

    /* Test 1: Basic addition */
    int result = clay_rust_add(2, 3);
    TEST_ASSERT(result == 5, "clay_rust_add(2, 3) == 5");

    /* Test 2: Addition with negative numbers */
    result = clay_rust_add(-10, 5);
    TEST_ASSERT(result == -5, "clay_rust_add(-10, 5) == -5");

    /* Test 3: Addition with zero */
    result = clay_rust_add(0, 0);
    TEST_ASSERT(result == 0, "clay_rust_add(0, 0) == 0");

    /* Test 4: Version check */
    int version = clay_rust_version();
    TEST_ASSERT(version == 1, "clay_rust_version() == 1");

    printf("\n=== All tests passed! ===\n");
    return 0;
}
