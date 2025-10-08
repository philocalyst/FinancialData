import dime
import gleam/string

pub type Conversion {
  Conversion(from: dime.Currency, to: dime.Currency)
}

/// Stripping the last char to match format expected by FRED
fn strip_last_char(input: String) -> String {
  let len = string.byte_size(input)
  case len {
    0 -> input
    _ -> string.slice(input, 0, len - 1)
  }
}

pub fn to_fred_string(input: Conversion) -> String {
  let first = input.from |> dime.alpha_code |> strip_last_char
  let second = input.to |> dime.alpha_code |> strip_last_char

  "DEX" <> first <> second
}
