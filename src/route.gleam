import conversion
import dime
import error
import gleam/list
import sources/fred_triplets

/// Converts an inputted amount to another amount, errors if no conversion route can be established
pub fn can_convert(
  amount: Float,
  desired_conversion: conversion.Conversion,
) -> Result(Float, error.FinanceError) {
  let example_conversions = [conversion.Conversion(dime.eur, dime.aed)]

  let available_fred = fred_triplets.available_conversions()

  case list.contains(available_fred, desired_conversion) {
    False -> Error(error.UnsupportedConversion)
    True -> Ok(0.0)
  }
}
