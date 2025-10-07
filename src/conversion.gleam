import dime

pub type Conversion {
  Conversion(from: dime.Currency, to: dime.Currency)
}

pub fn to_fred_string(input: Conversion) -> String {
  let first = input.from |> dime.display_name
  let second = input.from |> dime.display_name

  "DEX" <> first <> second
}
