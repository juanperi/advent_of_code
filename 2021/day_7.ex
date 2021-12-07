defmodule Support do
  def input() do
    File.read!("day_7.txt")
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  def distance(array, number, cost) do
    Enum.reduce(
      array,
      0,
      fn v, acc -> cost.(abs(v - number)) + acc end
    )
  end

  def walk(array, min, max, cost, _previous_distance \\ nil)

  def walk(_array, val, val, _cost, distance) do
    {val, distance}
  end

  def walk(array, min, max, cost, _previous_distance) do
    mid_point = floor((max - min) / 2) + min
    distance = Support.distance(array, mid_point, cost)
    next_distance = Support.distance(array, mid_point + 1, cost)

    {next_min, next_max, distance} =
      if distance < next_distance do
        {min, mid_point, distance}
      else
        {mid_point + 1, max, next_distance}
      end

    walk(array, next_min, next_max, cost, distance)
  end

  def cost(0), do: 0
  def cost(x), do: div(x * (x + 1), 2)
end

defmodule Main do
  def run() do
    initial = Support.input()
    last = List.last(initial)

    {_position, fuel} = Support.walk(initial, List.first(initial), last, &Function.identity/1)

    IO.inspect(fuel, label: "Part 1")

    {_position, fuel} = Support.walk(initial, List.first(initial), last, &Support.cost/1)
    IO.inspect(fuel, label: "Part 2")
  end
end

Main.run()
