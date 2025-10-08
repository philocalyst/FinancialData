import dime
import gleam/option.{type Option}
import gleam/time/timestamp

/// Typing for each conversion record
pub type Record {
  Record(
    at: timestamp.Timestamp,
    from: dime.Currency,
    to: dime.Currency,
    rate: Float,
    is_final: Option(Bool),
  )
}
