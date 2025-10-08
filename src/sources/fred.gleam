import common
import conversion
import gleam/float
import gleam/list
import gleam/option
import gleam/order
import gleam/result
import gleam/string
import gleam/time/calendar
import gleam/time/duration
import gleam/time/timestamp
import record
import source

pub fn date_to_fred_url_string(
  date: calendar.Date,
  utc_offset: duration.Duration,
) -> String {
  let midnight_utc = calendar.TimeOfDay(0, 0, 0, 0)
  let time = timestamp.from_calendar(date, midnight_utc, utc_offset)
  let rfc3339_string = timestamp.to_rfc3339(time, utc_offset)

  case list.first(string.split(rfc3339_string, on: "T")) {
    Ok(date_part) -> date_part
    // If extraction fails, something is fundamentally wrong with the timestamp format.
    Error(_) -> panic as "Failed to extract date part from RFC3339 string. "
  }
}

pub fn retrieve_fred(
  start: calendar.Date,
  end: calendar.Date,
  ops: conversion.Conversion,
) -> String {
  let utc_offset = calendar.utc_offset

  let start_date_str = date_to_fred_url_string(start, utc_offset)
  let end_date_str = date_to_fred_url_string(end, utc_offset)

  let host = "https://fred.stlouisfed.org/graph/fredgraph.csv"

  host
  <> "?id="
  <> ops |> conversion.to_fred_string
  <> "&cosd="
  <> start_date_str
  <> "&coed="
  <> end_date_str
  <> "&freq=Daily"
  <> "&transformation=lin"
  <> "&fam=avg"
}

fn records_to_representation(
  records: List(List(String)),
  source: source.Source,
) -> List(record.Record) {
  records
  // Here we're accessing a row of the original CSV
  |> list.map(fn(row) {
    // And the data within each row
    let assert [date, rate] = row

    // TODO: Better error handling here
    let rate = case float.parse(rate) {
      Ok(r) -> r
      Error(e) -> 0.0
    }

    let assert Ok(timestamp) =
      date
      |> common.parse_date
      |> result.map(fn(d) {
        timestamp.from_calendar(
          d,
          calendar.TimeOfDay(0, 0, 0, 0),
          duration.seconds(0),
        )
      })

    record.Record(
      at: timestamp,
      from: source.conversion.from,
      to: source.conversion.to,
      rate: rate,
      is_final: option.None,
    )
  })
}
