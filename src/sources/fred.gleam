import gleam/list
import gleam/string
import gleam/time/calendar
import gleam/time/duration
import gleam/time/timestamp

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
  id: String,
) -> String {
  let utc_offset = calendar.utc_offset

  let start_date_str = date_to_fred_url_string(start, utc_offset)
  let end_date_str = date_to_fred_url_string(end, utc_offset)

  let host = "https://fred.stlouisfed.org/graph/fredgraph.csv"

  host
  <> "?id="
  <> id
  <> "&cosd="
  <> start_date_str
  <> "&coed="
  <> end_date_str
  <> "&freq=Daily"
  <> "&transformation=lin"
  <> "&fam=avg"
}
