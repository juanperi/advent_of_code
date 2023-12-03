defmodule Day03 do
  require ExUnit.Assertions
  import ExUnit.Assertions

  @input File.read!("day_03.txt")

  def run() do
    example =
      """
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
      """

    assert part_1(example) == 4361
    IO.inspect(part_1(@input), label: "Part 1")

    assert part_2(example) == 467_835
    IO.inspect(part_2(@input), label: "Part 2")
  end

  def part_1(input) do
    {numbers, symbols} = parsed = parse(input)

    for {original_index, _} <- symbols,
        index <- sorroundings(original_index),
        match = Map.get(numbers, index) do
      match
    end
    |> Enum.uniq()
    |> Enum.map(fn {_id, value} -> value end)
    |> Enum.sum()
  end

  def part_2(input) do
    {numbers, symbols} = parsed = parse(input)

    for {original_index, symbol} <- symbols,
        symbol == "*",
        index <- sorroundings(original_index),
        match = Map.get(numbers, index) do
      {original_index, match}
    end
    |> Enum.uniq()
    |> Enum.group_by(fn {original_index, _} -> original_index end, fn {_, match} -> match end)
    |> Enum.map(fn {key, values} ->
      values
      |> Enum.map(fn {_, value} -> value end)
    end)
    |> Enum.filter(fn values -> length(values) == 2 end)
    |> Enum.map(fn [first, second] -> first * second end)
    |> Enum.sum()
  end

  def parse(input) do
    lines = String.split(input, "\n") |> Enum.with_index()

    numbers =
      for {line, line_number} <- lines do
        Regex.scan(~r/(\d+)/, line, return: :index)
        |> Enum.map(fn [_, {column, length}] ->
          id = System.unique_integer()
          {number, ""} = Integer.parse(String.slice(line, column, length))

          for column_number <- column..(column + length - 1) do
            {{line_number, column_number}, {id, number}}
          end
        end)
      end
      |> List.flatten()
      |> Enum.into(%{})

    symbols =
      for {line, line_number} <- lines do
        Regex.scan(~r/([^\.\d])/, line, return: :index)
        |> Enum.map(fn [_, {column, _}] ->
          {{line_number, column}, String.slice(line, column, 1)}
        end)
      end
      |> List.flatten()

    {numbers, symbols}
  end

  def sorroundings({row, column}) do
    [
      {row - 1, column - 1},
      {row - 1, column},
      {row - 1, column + 1},
      {row, column - 1},
      {row, column + 1},
      {row + 1, column - 1},
      {row + 1, column},
      {row + 1, column + 1}
    ]
  end
end

Day03.run()
