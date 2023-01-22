import gleeunit
import gleeunit/should
import read_file.{read_file}
import hug.{Location}

pub fn main() {
  gleeunit.main()
}

pub fn two_whitespace_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  assert Ok(output) = read_file(from: "./test/outputs/two_whitespace_test.txt")

  source
  |> hug.error(
    in: "input.txt",
    from: Location(row: 2, col: 11),
    to: Location(row: 2, col: 18),
    message: "mismatched types",
    hint: "expected type `Int` got type `Float`",
  )
  |> should.equal(output)
}

pub fn multi_whitespace_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  assert Ok(output) =
    read_file(from: "./test/outputs/multi_whitespace_test.txt")

  source
  |> hug.error(
    in: "input.txt",
    from: Location(row: 10, col: 9),
    to: Location(row: 10, col: 22),
    message: "wrong arity",
    hint: "list.map expects two arguments but only received one",
  )
  |> should.equal(output)
}

pub fn multi_line_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  assert Ok(output) = read_file(from: "./test/outputs/multi_line_test.txt")

  source
  |> hug.error(
    in: "input.txt",
    from: Location(row: 9, col: 9),
    to: Location(row: 12, col: 21),
    message: "very bad code",
    hint: "you really done mucked this one up",
  )
  |> should.equal(output)
}

pub fn warning_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  assert Ok(output) = read_file(from: "./test/outputs/warning_test.txt")

  source
  |> hug.warning(
    in: "input.txt",
    from: Location(row: 2, col: 7),
    to: Location(row: 2, col: 8),
    message: "unused variable",
    hint: "variable `a` is never referenced after assignment",
  )
  |> should.equal(output)
}

pub fn info_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input.txt")
  assert Ok(output) = read_file(from: "./test/outputs/info_test.txt")

  source
  |> hug.info(
    in: "input.txt",
    from: Location(row: 2, col: 7),
    to: Location(row: 2, col: 8),
    message: "unused variable",
    hint: "variable `a` is never referenced after assignment",
  )
  |> should.equal(output)
}
