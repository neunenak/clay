//! Clay Rust FFI - Proof of concept functions callable from C

use std::os::raw::c_int;

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
