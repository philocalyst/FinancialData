import conversion
import dime
import gleam/bool
import gleam/io
import gleam/result
import gleam/string

/// A type representing only the currency conversions supported by the system.
/// This acts as a "proof" that a conversion has been validated.
pub type SupportedConversion {
  USDToEUR
  EURToUSD
  GBPToUSD
}

/// This is the primary function for validating input against our known list.
pub fn to_supported_conversion(
  conversion: conversion.Conversion,
) -> Result(SupportedConversion, Nil) {
  case #(conversion.from, conversion.to) {
    #(from, to) if from == dime.usd && to == dime.eur -> Ok(USDToEUR)
    #(from, to) if from == dime.eur && to == dime.usd -> Ok(EURToUSD)
    #(from, to) if from == dime.gbp && to == dime.usd -> Ok(GBPToUSD)
    _ -> Error(Nil)
  }
}

/// A function to get the 'from' currency from a *validated* SupportedConversion.
pub fn from_currency(conversion: SupportedConversion) -> dime.Currency {
  case conversion {
    USDToEUR -> dime.usd
    EURToUSD -> dime.eur
    GBPToUSD -> dime.gbp
  }
}

/// A function to get the 'to' currency from a *validated* SupportedConversion.
pub fn to_currency(conversion: SupportedConversion) -> dime.Currency {
  case conversion {
    USDToEUR -> dime.eur
    EURToUSD -> dime.usd
    GBPToUSD -> dime.usd
  }
pub fn available_conversions() -> List(conversion.Conversion) {
  [
    conversion.Conversion(dime.usd, dime.eur),
    conversion.Conversion(dime.eur, dime.usd),
    conversion.Conversion(dime.gbp, dime.usd),
  ]
}

/// Performs a conversion, but only accepts the `SupportedConversion` type.
/// This ensures we don't attempt to convert unsupported pairs.
pub fn perform_conversion(
  amount: Float,
  conversion: SupportedConversion,
) -> Result(Float, String) {
  case conversion {
    USDToEUR -> Ok(amount *. 0.92)
    // Placeholder rate
    EURToUSD -> Ok(amount *. 1.08)
    // Placeholder rate
    GBPToUSD -> Ok(amount *. 1.25)
    // Placeholder rate
  }
}
