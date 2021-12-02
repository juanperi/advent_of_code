numbers =
  File.stream!("day_1.txt")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_integer/1)

reducer = fn numbers ->
  numbers
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.reduce(0, fn [a, b], acc -> if b > a, do: acc + 1, else: acc end)
end

result = reducer.(numbers)
IO.inspect(result, label: "Part 1")

result =
  numbers
  |> Enum.chunk_every(3, 1, :discard)
  |> Enum.map(&Enum.sum/1)
  |> reducer.()

IO.inspect(result, label: "Part 2")
