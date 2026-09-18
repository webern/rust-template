//! proj: TODO one sentence on what this library does.

/// The line the binary prints.
// TODO: placeholder so the template builds, tests and documents; replace with real code.
pub fn greeting() -> String {
    String::from("hello from proj")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn greeting_names_the_crate() {
        assert!(greeting().contains("proj"));
    }
}
