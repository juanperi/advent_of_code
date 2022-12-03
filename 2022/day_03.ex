defmodule Day03 do
  require ExUnit.Assertions
  import ExUnit.Assertions

  @input File.read!("day_03.txt")
  @test_input File.read!("day_03_test.txt")

  def run() do
    assert part_1(@test_input) == 157
    IO.inspect(part_1(@input), label: "Part 1:")

    assert part_2(@test_input) == 70
    IO.inspect(part_2(@input), label: "Part 2:")
  end

  def part_1(input) do
    input
    |> reshape()
    |> Enum.map(fn rucksack ->
      {first_sack, second_sack} = Enum.split(rucksack, div(length(rucksack), 2))
      first_sack = MapSet.new(first_sack)
      second_sack = MapSet.new(second_sack)

      [common] =
        first_sack
        |> MapSet.intersection(second_sack)
        |> MapSet.to_list()

      score_letter(common)
    end)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> reshape()
    |> Enum.chunk_every(3, 3, [])
    |> Enum.map(fn group ->
      Enum.reduce(group, nil, fn
        group, nil ->
          MapSet.new(group)

        group, acc ->
          MapSet.intersection(acc, MapSet.new(group))
      end)
    end)
    |> Enum.map(fn common ->
      [badge] = MapSet.to_list(common)
      score_letter(badge)
    end)
    |> Enum.sum()
  end

  defp reshape(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.split(row, "", trim: true)
    end)
  end

  def score_letter(<<letter>>) when letter in ?A..?Z do
    letter - ?A + 27
  end

  def score_letter(<<letter>>) when letter in ?a..?z do
    letter - ?a + 1
  end
end

Day03.run()
