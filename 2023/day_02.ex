Mix.install([
  {:nimble_parsec, "~> 1.4"}
])

defmodule Day02.Parser do
  import NimbleParsec

  id =
    ignore(string("Game "))
    |> integer(min: 1, max: 5)
    |> ignore(string(":"))

  pull =
    times(
      ignore(string(" "))
      |> integer(min: 1)
      |> ignore(string(" "))
      |> choice([string("red"), string("green"), string("blue")])
      |> ignore(optional(string(","))),
      min: 1
    )
    |> reduce(:matches_to_map)
    |> ignore(optional(string(";")))

  pulls = repeat(pull)

  game =
    id
    |> wrap(pulls)
    |> ignore(optional(string("\n")))
    |> reduce(:game_to_map)

  games = game |> repeat()

  defparsec(:games, games)

  def parse(input) do
    {:ok, result, "", %{}, _, _} = games(input)
    result
  end

  defp matches_to_map(raw) do
    for [k, v] <- Enum.chunk_every(raw, 2),
        do: {String.to_atom(v), k},
        into: %{blue: 0, red: 0, green: 0}
  end

  defp game_to_map(raw) do
    [id, pulls] = raw
    %{id: id, pulls: pulls}
  end
end

defmodule Day02 do
  require ExUnit.Assertions
  import ExUnit.Assertions
  alias Day02.Parser

  @input File.read!("day_02.txt")

  def run() do
    example =
      """
      Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
      Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
      Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
      Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
      """

    assert part_1(example) == 8
    IO.inspect(part_1(@input), label: "Part 1")

    assert part_2(example) == 2286
    IO.inspect(part_2(@input), label: "Part 2")
  end

  def part_1(input) do
    games = Parser.parse(input)
    valid = fn entry -> entry.red <= 12 && entry.green <= 13 && entry.blue <= 14 end

    games
    |> Enum.filter(fn game -> Enum.all?(game.pulls, valid) end)
    |> Enum.map(& &1.id)
    |> Enum.sum()
  end

  def part_2(input) do
    games = Parser.parse(input)

    games
    |> Enum.map(fn game ->
      pulls =
        Enum.reduce(game.pulls, %{green: 0, red: 0, blue: 0}, fn pull, acc ->
          Map.merge(acc, pull, fn _k, v1, v2 -> Enum.max([v1, v2]) end)
        end)

      pulls.green * pulls.red * pulls.blue
    end)
    |> Enum.sum()
  end
end

Day02.run()
