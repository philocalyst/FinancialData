import gleam/http/request
import gleam/http/response
import gleam/httpc
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
  let link =
    retrieve_fred(
      calendar.Date(2020, calendar.October, 7),
      calendar.Date(2020, calendar.October, 7),
      "DEXUSUK",
      Linear,
      Average,
    )

  let assert Ok(base_request) = request.to(link)

  let req =
    request.prepend_header(
      base_request,
      "accept",
      "application/vnd.hmrc.1.0+json",
    )

  // Send the HTTP request to the server
  let assert Ok(resp) = httpc.send(req)

  // Ensure we get a response record back
  assert resp.status == 200

  let csv_data = resp.body

  io.println(csv_data)
}

pub type Form {
  Linear
}

pub type Aggregation {
  Average
}

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
    Error(_) -> panic("Failed to extract date part from RFC3339 string. ")
  }
}

pub fn retrieve_fred(
  start: calendar.Date,
  end: calendar.Date,
  id: String,
  form: Form,
  aggregation: Aggregation,
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
