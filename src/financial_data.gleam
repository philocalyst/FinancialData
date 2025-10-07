import gleam/io

type Links {
  FRED
}

pub fn main() -> Nil {
  let data = "https://fred.stlouisfed.org/graph/fredgraph.csv"
  io.println("Hello from financialdata!")
}

pub fn retrieve_fred(start: i32)
