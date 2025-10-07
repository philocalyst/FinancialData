import dime

pub type Conversion {
  Conversion(from: dime.Currency, to: dime.Currency)
}

pub fn to_fred_string(input: Conversion) -> String {
  let first = input.from |> dime.alpha_code
  let second = input.to |> dime.alpha_code

  "DEX" <> first <> second
}
