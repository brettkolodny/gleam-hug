// IMPORTS --------------------------------------------------------------------

import gleam/int
import gleam/list
import gleam/string
import gleam_community/ansi
import gleam/option.{None, Some}

// TYPES ----------------------------------------------------------------------

pub type Location {
  Location(row: Int, col: Int)
}

type Output {
  Error
  Warning
  Info
}

// ----------------------------------------------------------------------------

///
pub fn error(
  in file_name: String,
  containing source: String,
  from start: Location,
  to end: Location,
  message msg: String,
  hint hint: String,
) -> String {
  output(file_name, source, start, end, msg, hint, Error)
}

pub fn warning(
  in file_name: String,
  containing source: String,
  from start: Location,
  to end: Location,
  message msg: String,
  hint hint: String,
) -> String {
  output(file_name, source, start, end, msg, hint, Warning)
}

pub fn info(
  in file_name: String,
  containing source: String,
  from start: Location,
  to end: Location,
  message msg: String,
  hint hint: String,
) -> String {
  output(file_name, source, start, end, msg, hint, Info)
}

// ----------------------------------------------------------------------------

fn output(
  file_name: String,
  source: String,
  start: Location,
  end: Location,
  err: String,
  hint: String,
  output: Output,
) {
  let error_header = construct_header(err, output)

  let error_body = construct_error_body(file_name, source, start, end, output)

  string.join([error_header, error_body, "", hint], "\n")
}

//
fn relevant_lines(
  source: String,
  start: Location,
  end: Location,
) -> List(String) {
  source
  |> string.split(on: "\n")
  |> list.index_fold(
    [],
    fn(lines, line, index) {
      case index + 1 >= start.row && index + 1 <= end.row {
        True -> [line, ..lines]
        False -> lines
      }
    },
  )
  |> list.reverse()
}

//
fn underline_errors(
  error_lines: List(String),
  start: Location,
  end: Location,
  output: Output,
) -> List(String) {
  let colour = case output {
    Error -> ansi.red
    Warning -> ansi.yellow
    Info -> ansi.blue
  }

  use index, line <- list.index_map(error_lines)

  case string.trim(line) {
    "" -> ""
    _ ->
      case index == 0 {
        True -> {
          let white_space = string.repeat(" ", start.col - 1)

          let underline_end = case end.row == start.row {
            True -> end.col - start.col
            False -> string.length(line) - string.length(white_space)
          }

          white_space <> colour(string.repeat("~", underline_end))
        }

        False -> {
          let line_length = string.length(line)
          let line_length_post_trim = string.length(string.trim_left(line))

          let num_white_space = line_length - line_length_post_trim

          let white_space = string.repeat(" ", num_white_space)

          white_space <> colour(string.repeat("~", line_length_post_trim))
        }
      }
  }
}

fn construct_header(message: String, output: Output) -> String {
  case output {
    Error -> ansi.red("error: ") <> message
    Warning -> ansi.yellow("warning: ") <> message
    Info -> ansi.blue("info: ") <> message
  }
}

//
fn construct_error_body(
  file_name: String,
  source: String,
  start: Location,
  end: Location,
  output: Output,
) -> String {
  let left_padding =
    int.max(
      string.length(int.to_string(start.row)),
      string.length(int.to_string(end.row)),
    ) - 1

  let body_start =
    string.repeat(" ", left_padding) <> "  ┌─ " <> file_name <> ":" <> int.to_string(
      start.row,
    ) <> ":" <> int.to_string(start.col)

  let lines_with_errors = relevant_lines(source, start, end)

  let underlines = underline_errors(lines_with_errors, start, end, output)

  let num_whitespace = white_space_to_remove(lines_with_errors)

  let body =
    list.zip(lines_with_errors, underlines)
    |> list.index_map(fn(index, input) {
      construct_output_line(
        input,
        index + start.row,
        num_whitespace,
        left_padding,
      )
    })
    |> string.join("\n")

  string.join(
    [
      body_start,
      string.repeat(" ", left_padding) <> "  │",
      body,
      string.repeat(" ", left_padding) <> "  │",
    ],
    "\n",
  )
}

//
fn construct_output_line(
  input: #(String, String),
  row: Int,
  white_space: Int,
  left_padding: Int,
) -> String {
  let #(error_line, underline) = input

  let line_number_padding = left_padding - string.length(int.to_string(row)) + 1

  let error_line =
    ansi.green(int.to_string(row)) <> string.repeat(" ", line_number_padding) <> " │ " <> trim_left_by(
      error_line,
      white_space,
    )

  case string.length(underline) {
    0 -> error_line
    _ -> {
      let underline_line =
        string.repeat(" ", left_padding) <> "  │ " <> trim_left_by(
          underline,
          white_space,
        )

      string.join([error_line, underline_line], "\n")
    }
  }
}

//
fn white_space_to_remove(lines: List(String)) -> Int {
  lines
  |> list.fold(
    None,
    fn(acc, line) {
      case string.trim(line) {
        "" -> acc
        _ -> {
          let white_space =
            string.length(line) - {
              line
              |> string.trim_left()
              |> string.length()
            }

          case acc {
            Some(count) -> Some(int.min(count, white_space))
            None -> Some(white_space)
          }
        }
      }
    },
  )
  |> option.unwrap(0)
}

//
fn trim_left_by(str: String, num_whitespace: Int) -> String {
  let string_length = string.length(str)

  string.slice(from: str, at_index: num_whitespace, length: string_length)
}
