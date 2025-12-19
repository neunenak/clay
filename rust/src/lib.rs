//! Clay Rust FFI - Porting Clay functions from C to Rust
//!
//! This module provides Rust implementations of Clay functions that can be
//! called from C code. The goal is incremental migration of Clay from C to Rust.

use std::os::raw::c_int;

// =============================================================================
// C-compatible type definitions
// These must exactly match the C struct layouts in clay.h
// =============================================================================

/// Matches Clay_String in clay.h
#[repr(C)]
pub struct ClayString {
    pub is_statically_allocated: bool,
    pub length: i32,
    pub chars: *const std::os::raw::c_char,
}

/// Matches Clay_ErrorHandler in clay.h
#[repr(C)]
pub struct ClayErrorHandler {
    pub error_handler_function: Option<unsafe extern "C" fn(*const std::ffi::c_void)>,
    pub user_data: *mut std::ffi::c_void,
}

/// Matches Clay_BooleanWarnings in clay.h
#[repr(C)]
pub struct ClayBooleanWarnings {
    pub max_elements_exceeded: bool,
    pub max_render_commands_exceeded: bool,
    pub max_text_measure_cache_exceeded: bool,
    pub text_measurement_function_not_set: bool,
}

/// Matches Clay__Warning in clay.h
#[repr(C)]
pub struct ClayWarning {
    pub base_message: ClayString,
    pub dynamic_message: ClayString,
}

/// Matches Clay__WarningArray in clay.h
#[repr(C)]
pub struct ClayWarningArray {
    pub capacity: i32,
    pub length: i32,
    pub internal_array: *mut ClayWarning,
}

/// Matches Clay_Vector2 in clay.h
#[repr(C)]
pub struct ClayVector2 {
    pub x: f32,
    pub y: f32,
}

/// Matches Clay_PointerDataInteractionState in clay.h (packed enum = u8)
#[repr(u8)]
pub enum ClayPointerDataInteractionState {
    PressedThisFrame = 0,
    Pressed = 1,
    ReleasedThisFrame = 2,
    Released = 3,
}

/// Matches Clay_PointerData in clay.h
#[repr(C)]
pub struct ClayPointerData {
    pub position: ClayVector2,
    pub state: ClayPointerDataInteractionState,
}

/// Matches Clay_Dimensions in clay.h
#[repr(C)]
pub struct ClayDimensions {
    pub width: f32,
    pub height: f32,
}

/// Matches Clay_ElementId in clay.h
#[repr(C)]
pub struct ClayElementId {
    pub id: u32,
    pub offset: u32,
    pub base_id: u32,
    pub string_id: ClayString,
}

/// Partial Clay_Context - only fields up to and including debugModeEnabled
/// This must match the exact memory layout of the beginning of Clay_Context in clay.h
#[repr(C)]
pub struct ClayContext {
    pub max_element_count: i32,
    pub max_measure_text_cache_word_count: i32,
    pub warnings_enabled: bool,
    pub error_handler: ClayErrorHandler,
    pub boolean_warnings: ClayBooleanWarnings,
    pub warnings: ClayWarningArray,

    pub pointer_info: ClayPointerData,
    pub layout_dimensions: ClayDimensions,
    pub dynamic_element_index_base_hash: ClayElementId,
    pub dynamic_element_index: u32,
    pub debug_mode_enabled: bool,
    // Note: Fields after debug_mode_enabled are not needed for Clay_IsDebugModeEnabled
    // They will be added as more functions are ported
}

// =============================================================================
// External C symbols
// =============================================================================

extern "C" {
    /// The global Clay context pointer, defined in clay.h
    static Clay__currentContext: *mut ClayContext;
}

// =============================================================================
// Ported Clay functions
// =============================================================================

/// Returns whether debug mode is currently enabled.
/// Rust implementation of Clay_IsDebugModeEnabled from clay.h
#[no_mangle]
pub extern "C" fn Clay_IsDebugModeEnabled() -> bool {
    unsafe {
        if Clay__currentContext.is_null() {
            return false;
        }
        (*Clay__currentContext).debug_mode_enabled
    }
}

// =============================================================================
// Proof of concept functions (to be removed later)
// =============================================================================

/// Simple addition function as a proof of concept FFI.
/// Callable from C as: int32_t clay_rust_add(int32_t a, int32_t b);
#[no_mangle]
pub extern "C" fn clay_rust_add(a: c_int, b: c_int) -> c_int {
    a.wrapping_add(b)
}

/// Returns a constant to verify the Rust library is linked correctly.
#[no_mangle]
pub extern "C" fn clay_rust_version() -> c_int {
    1
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        assert_eq!(clay_rust_add(2, 3), 5);
        assert_eq!(clay_rust_add(-1, 1), 0);
    }

    #[test]
    fn test_version() {
        assert_eq!(clay_rust_version(), 1);
    }
}
