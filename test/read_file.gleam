@external(erlang, "read_file_ffi", "read_file")
@external(javascript, "./read_file_ffi.mjs", "readFile")
pub fn read_file(from path: String) -> Result(String, Nil)