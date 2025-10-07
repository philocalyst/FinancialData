import gleam/http/request
import gleam/httpc
import gleam/time/calendar
import gsv
import sources/fred.{retrieve_fred}

type Links {
  FRED
}

pub fn main() -> Nil {
  let link =
    retrieve_fred(
      calendar.Date(2020, calendar.October, 7),
      calendar.Date(2025, calendar.October, 7),
      "DEXUSUK",
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

  let assert Ok(data) = gsv.to_lists(resp.body, ",")

  echo data

  Nil
}
