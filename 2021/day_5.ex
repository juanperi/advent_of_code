defmodule Support do
  def input() do
    rows =
      File.read!("day_5.txt")
      |> String.split(["\n", ",", " -> "], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(4)
      |> Enum.map(&List.to_tuple/1)
  end

  def straight_line?({x1, y1, x2, y2}) when x1 == x2 or y1 == y2, do: true
  def straight_line?(_), do: false

  def fill_points({x1, y1, x2, y2}) do
    {dx, dy} = {x2 - x1, y2 - y1}
    slope = {step(dx), step(dy)}
    do_fill({x1, y1}, {x2, y2}, slope, [])
  end

  defp step(0), do: 0
  defp step(x) when x > 0, do: 1
  defp step(x) when x < 0, do: -1

  defp do_fill(point, point, _slope, acc) do
    [point | acc]
  end

  defp do_fill({x1, y1} = point, end_point, {dx, dy} = slope, acc) do
    new_point = {x1 + dx, y1 + dy}
    do_fill(new_point, end_point, slope, [point | acc])
  end

  def single_point?({_, [_]}), do: true
  def single_point?({_, _}), do: false
end

defmodule Main do
  def run() do
    overlapping_points =
      Support.input()
      |> Enum.filter(&Support.straight_line?/1)
      |> Enum.flat_map(&Support.fill_points/1)
      |> Enum.group_by(& &1)
      |> Enum.reject(&Support.single_point?/1)
      |> length

    IO.inspect(overlapping_points, label: "Part 1")

    overlapping_points =
      Support.input()
      |> Enum.flat_map(&Support.fill_points/1)
      |> Enum.group_by(& &1)
      |> Enum.reject(&Support.single_point?/1)
      |> length

    IO.inspect(overlapping_points, label: "Part 2")
  end
end

Main.run()
