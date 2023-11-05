import gleeunit
import gleeunit/should
import read_file.{read_file}
import hug

pub fn main() {
  gleeunit.main()
}

pub fn two_whitespace_test() {
  let assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  let assert Ok(output) =
    read_file(from: "./test/outputs/two_whitespace_test.txt")

  source
  |> hug.error(
    in: "input.txt",
    from: #(2, 11),
    to: #(2, 18),
    message: "mismatched types",
    hint: "expected type `Int` got type `Float`",
  )
  |> should.equal(output)
}

pub fn multi_whitespace_test() {
  let assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  let assert Ok(output) =
    read_file(from: "./test/outputs/multi_whitespace_test.txt")

  source
  |> hug.error(
    in: "input.txt",
    from: #(10, 9),
    to: #(10, 22),
    message: "wrong arity",
    hint: "list.map expects two arguments but only received one",
  )
  |> should.equal(output)
}

pub fn multi_line_test() {
  let assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  let assert Ok(output) = read_file(from: "./test/outputs/multi_line_test.txt")

  source
  |> hug.error(
    in: "input.txt",
    from: #(9, 9),
    to: #(12, 21),
    message: "very bad code",
    hint: "you really done mucked this one up",
  )
  |> should.equal(output)
}

pub fn warning_test() {
  let assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  let assert Ok(output) = read_file(from: "./test/outputs/warning_test.txt")

  source
  |> hug.warning(
    in: "input.txt",
    from: #(2, 7),
    to: #(2, 8),
    message: "unused variable",
    hint: "variable `a` is never referenced after assignment",
  )
  |> should.equal(output)
}

pub fn info_test() {
  let assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  let assert Ok(output) = read_file(from: "./test/outputs/info_test.txt")

  source
  |> hug.info(
    in: "input.txt",
    from: #(2, 7),
    to: #(2, 8),
    message: "unused variable",
    hint: "variable `a` is never referenced after assignment",
  )
  |> should.equal(output)
}

pub fn two_line_error_test() {
  let assert Ok(source) = read_file(from: "./test/inputs/two_line_input.txt")
  let assert Ok(output) = read_file(from: "./test/outputs/two_line_test.txt")

  source
  |> hug.error(
    in: "test",
    from: #(1, 5),
    to: #(2, 23),
    message: "invalid syntax",
    hint: "blah",
  )
  |> should.equal(output)
}
