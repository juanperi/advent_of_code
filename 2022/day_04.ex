defmodule Day04 do
  require ExUnit.Assertions
  import ExUnit.Assertions

  @input File.read!("day_04.txt")
  @test_input File.read!("day_04_test.txt")

  def run() do
    assert part_1(@test_input) == 2
    IO.inspect(part_1(@input), label: "Part 1:")

    assert part_2(@test_input) == 4
    IO.inspect(part_2(@input), label: "Part 2:")
  end

  def part_1(input) do
    input
    |> reshape()
    |> Enum.filter(fn [first, second] -> full_overlap?(first, second) end)
    |> length()
  end

  def part_2(input) do
    input
    |> reshape()
    |> Enum.filter(fn [first, second] -> !Range.disjoint?(first, second) end)
    |> length()
  end

  defp reshape(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.split(row, ",", trim: true)
      |> Enum.map(&map_range/1)
    end)
  end

  def score_letter(<<letter>>) when letter in ?A..?Z do
    letter - ?A + 27
  end

  def score_letter(<<letter>>) when letter in ?a..?z do
    letter - ?a + 1
  end

  defp map_range(raw) do
    [first, last] =
      String.split(raw, "-", trim: true)
      |> Enum.map(&String.to_integer/1)

    Range.new(first, last)
  end

  defp full_overlap?(range1, range2) do
    do_full_overlap?(range1, range2) || do_full_overlap?(range2, range1)
  end

  defp do_full_overlap?(%{first: first, last: last}, %{first: first_b, last: last_b})
       when first_b >= first and last_b <= last,
       do: true

  defp do_full_overlap?(_, _), do: false
end

Day04.run()
