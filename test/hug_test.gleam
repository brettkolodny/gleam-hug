import gleeunit
import gleeunit/should
import read_file.{read_file}
import hug.{Location}

pub fn main() {
  gleeunit.main()
}

pub fn two_whitespace_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input_1.txt")
  assert Ok(output_1) = read_file(from: "./test/outputs/output_1.txt")
  assert Ok(output_2) = read_file(from: "./test/outputs/output_2.txt")

  source
  |> hug.error(
    in: "input_1.txt",
    from: Location(row: 2, col: 11),
    to: Location(row: 2, col: 18),
    error: "mismatched types",
    hint: "expected type `Int` got type `Float`",
  )
  |> should.equal(output_1)

  source
  |> hug.error(
    in: "input_1.txt",
    from: Location(row: 4, col: 11),
    to: Location(row: 4, col: 25),
    error: "mismatched types",
    hint: "lists can only contain one type",
  )
  |> should.equal(output_2)
}

pub fn multi_whitespace_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input_1.txt")
  assert Ok(output) = read_file(from: "./test/outputs/output_3.txt")

  source
  |> hug.error(
    in: "input_1.txt",
    from: Location(row: 10, col: 9),
    to: Location(row: 10, col: 22),
    error: "wrong arity",
    hint: "list.map expects two arguments but only received one",
  )
  |> should.equal(output)
}

pub fn multi_line_error_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input_1.txt")
  assert Ok(output) = read_file(from: "./test/outputs/output_4.txt")

  source
  |> hug.error(
    in: "input_1.txt",
    from: Location(row: 9, col: 9),
    to: Location(row: 12, col: 21),
    error: "very bad code",
    hint: "you really done mucked this one up",
  )
  |> should.equal(output)
}

pub fn warning_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input_1.txt")
  assert Ok(output) = read_file(from: "./test/outputs/output_5.txt")

  source
  |> hug.warning(
    in: "input_1.txt",
    from: Location(row: 2, col: 7),
    to: Location(row: 2, col: 8),
    error: "unused variable",
    hint: "variable `a` is never referenced after assignment",
  )
  |> should.equal(output)
}

pub fn info_test() {
  assert Ok(source) = read_file(from: "./test/inputs/input_1.txt")
  assert Ok(output) = read_file(from: "./test/outputs/output_6.txt")

  source
  |> hug.info(
    in: "input_1.txt",
    from: Location(row: 2, col: 7),
    to: Location(row: 2, col: 8),
    error: "unused variable",
    hint: "variable `a` is never referenced after assignment",
  )
  |> should.equal(output)
}
