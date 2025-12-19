/*
 * Clay Rust FFI Test
 *
 * This test verifies that Rust functions (both proof-of-concept
 * and ported Clay functions) are correctly linked and callable from C code.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Include Clay implementation - this defines Clay__currentContext */
#define CLAY_IMPLEMENTATION
#include "../../clay.h"

#include "clay_rust.h"

#define TEST_ASSERT(cond, msg) do { \
    if (!(cond)) { \
        fprintf(stderr, "FAILED: %s\n", msg); \
        return 1; \
    } \
    printf("PASSED: %s\n", msg); \
} while(0)

/* Dummy text measurement function for Clay initialization */
static Clay_Dimensions measure_text(Clay_StringSlice text, Clay_TextElementConfig *config, void *userData) {
    (void)text; (void)config; (void)userData;
    return (Clay_Dimensions){0, 0};
}

/* Error handler for Clay */
static void handle_error(Clay_ErrorData error) {
    fprintf(stderr, "Clay error: %.*s\n", error.errorText.length, error.errorText.chars);
}

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

    printf("\n--- Testing ported Clay functions ---\n\n");

    /* Initialize Clay - this sets up Clay__currentContext */
    uint32_t mem_size = Clay_MinMemorySize();
    void *clay_memory = malloc(mem_size);
    Clay_Arena arena = Clay_CreateArenaWithCapacityAndMemory(mem_size, clay_memory);
    Clay_Initialize(arena, (Clay_Dimensions){800, 600}, (Clay_ErrorHandler){handle_error, NULL});
    Clay_SetMeasureTextFunction(measure_text, NULL);

    /* Test 5: Clay_IsDebugModeEnabled (Rust implementation) - default is false */
    bool debug_enabled = Clay_IsDebugModeEnabled();
    TEST_ASSERT(debug_enabled == false, "Clay_IsDebugModeEnabled() == false (default)");

    /* Test 6: Enable debug mode via C function, check via Rust function */
    Clay_SetDebugModeEnabled(true);
    debug_enabled = Clay_IsDebugModeEnabled();
    TEST_ASSERT(debug_enabled == true, "Clay_IsDebugModeEnabled() == true after enabling");

    /* Test 7: Disable debug mode, verify via Rust function */
    Clay_SetDebugModeEnabled(false);
    debug_enabled = Clay_IsDebugModeEnabled();
    TEST_ASSERT(debug_enabled == false, "Clay_IsDebugModeEnabled() == false after disabling");

    free(clay_memory);

    printf("\n=== All tests passed! ===\n");
    return 0;
}
