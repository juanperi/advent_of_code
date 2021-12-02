instructions =
  File.stream!("day_2.txt")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(fn [direction, number] -> {String.to_atom(direction), String.to_integer(number)} end)

{horizontal, depth} =
  instructions
  |> Enum.reduce(
    {0, 0},
    fn
      {:forward, number}, {horizontal, depth} -> {horizontal + number, depth}
      {:down, number}, {horizontal, depth} -> {horizontal, depth + number}
      {:up, number}, {horizontal, depth} -> {horizontal, depth - number}
    end
  )
IO.inspect "Part 1"
IO.inspect horizontal, label: "horizontal"
IO.inspect depth, label: "depth"
IO.inspect horizontal * depth, label: "multiplication"

{horizontal, depth, aim} =
  instructions
  |> Enum.reduce(
    {0, 0, 0},
    fn
      {:forward, number}, {horizontal, depth, aim} -> {horizontal + number, depth + aim * number, aim}
      {:down, number}, {horizontal, depth, aim} -> {horizontal, depth, aim + number}
      {:up, number}, {horizontal, depth, aim} -> {horizontal, depth, aim - number}
    end
  )
IO.inspect "Part 2"
IO.inspect horizontal, label: "horizontal"
IO.inspect depth, label: "depth"
IO.inspect aim, label: "aim"
IO.inspect horizontal * depth, label: "multiplication"
