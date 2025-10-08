pub type FinancialCalendar {
  FED
}

pub type PriceType {
  Mid
  Ask
  Best
  Last
  Fixing
}

pub type Source {
  Source(
    invertible: Bool,
    source: Uri,
    license: String,
    calendar: FinancialCalendar,
    name: String,
    price_type: PriceType,
  )
}
