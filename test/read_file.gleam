import gleam/result

if erlang {
  import gleam/erlang/file
}

pub fn read_file(from path: String) -> Result(String, Nil) {
  do_read_file(path)
}

if erlang {
  fn do_read_file(path: String) -> Result(String, Nil) {
    file.read(path)
    |> result.map_error(fn(_) { Nil })
  }
}

if javascript {
  external fn do_read_file(path: String) -> Result(String, Nil) =
    "./read_file_ffi.mjs" "readFile"
}
