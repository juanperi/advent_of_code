Mix.install([
  {:nimble_parsec, "~> 1.4"}
])

defmodule Day04.Parser do
  import NimbleParsec

  id =
    ignore(string("Card "))
    |> repeat(ignore(string(" ")))
    |> integer(min: 1)
    |> ignore(string(":"))

  list =
    repeat(
      repeat(ignore(string(" ")))
      |> integer(min: 1)
    )

  row =
    id
    |> wrap(list)
    |> ignore(string(" | "))
    |> wrap(list)
    |> ignore(string("\n"))
    |> reduce(:card_to_map)

  cards = row |> repeat()

  defparsec(:cards, cards)

  def parse(input) do
    {:ok, result, "", %{}, _, _} = cards(input)
    result
  end

  defp card_to_map(raw) do
    [id, winners, mine] = raw
    %{id: id, winners: MapSet.new(winners), mine: MapSet.new(mine)}
  end
end

defmodule Day04 do
  require ExUnit.Assertions
  import ExUnit.Assertions
  alias Day04.Parser

  @input File.read!("day_04.txt")

  def run() do
    example =
      """
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
      """

    assert part_1(example) == 13
    IO.inspect(part_1(@input), label: "Part 1")

    assert part_2(example) == 30
    IO.inspect(part_2(@input), label: "Part 2")
  end

  def part_1(input) do
    cards = Parser.parse(input)

    for card <- cards do
      {_, score} = score_card(card)
      score
    end
    |> Enum.sum()
  end

  def part_2(input) do
    cards = Parser.parse(input)
    ids = Enum.map(cards, & &1.id)
    scored_map = Enum.into(cards, %{}, &{&1.id, %{count: 1, wins: elem(score_card(&1), 0)}})

    Enum.reduce(ids, scored_map, fn id, acc ->
      card = Map.fetch!(acc, id)

      updates =
        for index <- 1..card.wins//1, into: %{} do
          next_id = id + index
          next_game = Map.get(acc, next_id)
          {next_id, %{next_game | count: card.count}}
        end

      Map.merge(acc, updates, fn _k, v1, v2 ->
        %{v1 | count: v1.count + v2.count}
      end)
    end)
    |> Enum.map(fn {_id, card} -> card.count end)
    |> Enum.sum()
  end

  defp score_card(card) do
    numbers_won =
      card.winners
      |> MapSet.intersection(card.mine)
      |> MapSet.size()

    {numbers_won, floor(:math.pow(2, numbers_won - 1))}
  end
end

Day04.run()
