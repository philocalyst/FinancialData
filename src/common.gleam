import gleam/int
import gleam/result
import gleam/string
import gleam/time/calendar

pub fn parse_date(date_str: String) -> Result(calendar.Date, String) {
  case string.split(date_str, "-") {
    [year_str, month_str, day_str] -> {
      use year <- result.try(
        int.parse(year_str)
        |> result.replace_error("Invalid year"),
      )
      use month_int <- result.try(
        int.parse(month_str)
        |> result.replace_error("Invalid month number"),
      )
      use day <- result.try(
        int.parse(day_str)
        |> result.replace_error("Invalid day"),
      )
      use month <- result.try(int_to_month(month_int))

      let date = calendar.Date(day, month, year)

      Ok(date)
    }
    _ -> Error("Expected format: YYYY-MM-DD")
  }
}

fn int_to_month(m: Int) -> Result(calendar.Month, String) {
  case m {
    1 -> Ok(calendar.January)
    2 -> Ok(calendar.February)
    3 -> Ok(calendar.March)
    4 -> Ok(calendar.April)
    5 -> Ok(calendar.May)
    6 -> Ok(calendar.June)
    7 -> Ok(calendar.July)
    8 -> Ok(calendar.August)
    9 -> Ok(calendar.September)
    10 -> Ok(calendar.October)
    11 -> Ok(calendar.November)
    12 -> Ok(calendar.December)
    _ -> Error("Month must be 1-12, got " <> int.to_string(m))
  }
}
