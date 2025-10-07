import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/time/calendar
import gleam/time/duration
import gleam/time/timestamp
import gleam/uri

type Links {
  FRED
}

pub fn main() -> Nil {
  let data =
    retrieve_fred(
      calendar.Date(2025, calendar.October, 7),
      calendar.Date(2025, calendar.October, 7),
      "DEXUSUK",
      Linear,
      Average,
    )
  io.println(data)
}

pub type Form {
  Linear
}

pub type Aggregation {
  Average
}

pub fn retrieve_fred(
  start: calendar.Date,
  end: calendar.Date,
  id: String,
  form: Form,
  aggregation: Aggregation,
) -> String {
  let midnight_utc = calendar.TimeOfDay(0, 0, 0, 0)
  let utc_offset = calendar.utc_offset

  // Convert to timestamp
  let start_time =
    timestamp.to_rfc3339(
      timestamp.from_calendar(start, midnight_utc, utc_offset),
      utc_offset,
    )
  let end_time =
    timestamp.to_rfc3339(
      timestamp.from_calendar(end, midnight_utc, utc_offset),
      utc_offset,
    )

  let start_date = list.first(string.split(start_time, on: "T"))
  let end_date = list.first(string.split(end_time, on: "T"))

  let host = "https://fred.stlouisfed.org/graph/fredgraph.csv"

  host
  <> "?id="
  <> id
  <> "&cosd="
  <> start_date
  <> "&cosd="
  <> end_date
  <> "&freq=Daily"
  <> "&transformation=lin"
  <> "&fam=avg"
}
