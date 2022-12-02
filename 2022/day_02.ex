defmodule Day02 do
  def part_1(input) do
    input
    |> reshape()
    |> Enum.map(fn {_, me} = match ->
      score_match(match, &score_gesture/1) + score_gesture(me)
    end)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> reshape()
    |> Enum.map(fn match ->
      {_, me} = match = get_hinted_gesture(match)

      score_match(match, &score_gesture/1) + score_gesture(me)
    end)
    |> Enum.sum()
  end

  @scores [A: 1, B: 2, C: 3, X: 1, Y: 2, Z: 3]
  def score_gesture(value) do
    @scores[value]
  end

  @hinted_scores [:A, :B, :C]
  def get_hinted_gesture({them, hint}) do
    direction =
      case hint do
        :X -> -1
        :Y -> 0
        :Z -> 1
      end

    index = rem(Enum.find_index(@hinted_scores, fn v -> v == them end) + direction, 3)

    {them, Enum.at(@hinted_scores, index)}
  end

  def score_match({them, me}, scorer_fn) do
    score_them = scorer_fn.(them)
    score_me = scorer_fn.(me)

    cond do
      score_them == score_me -> 3
      rem(score_them, 3) == score_me - 1 -> 6
      true -> 0
    end
  end

  defp reshape(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_atom/1)
      |> List.to_tuple()
    end)
  end
end

ExUnit.start(autorun: false)

defmodule Test do
  use ExUnit.Case, async: true

  @input File.read!("day_02.txt")
  @test_input File.read!("day_02_test.txt")

  test "part 1 example" do
    assert Day02.part_1(@test_input) === 15
    IO.inspect(Day02.part_1(@input), label: "\nPart 1:")
  end

  test "part 2 example" do
    assert Day02.part_2(@test_input) === 12
    IO.inspect(Day02.part_2(@input), label: "\nPart 2:")
  end
end

ExUnit.run()
