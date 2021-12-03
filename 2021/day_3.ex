defmodule Support do
  def input() do
    File.read!("day_3.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def transpose(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def negate("0"), do: "1"
  def negate("1"), do: "0"

  def group_by_position(matrix, position) do
    Enum.group_by(
      matrix,
      fn row -> Enum.at(row, position) end
    )
  end

  def find_most_common(matrix, sorter) do
    sorter =
      case sorter do
        :gte -> &>=/2
        :lte -> &<=/2
      end

    find_most_common(matrix, 0, sorter)
  end

  def find_most_common([row], _, _) do
    row
  end

  def find_most_common(matrix, position, sorter) do
    grouped = group_by_position(matrix, position)
    {_, max_matrix} = Enum.max_by(grouped, fn {k, v} -> {length(v), k} end, sorter)
    find_most_common(max_matrix, position + 1, sorter)
  end

  def row_to_number(row) do
    row |> Enum.join("") |> String.to_integer(2)
  end
end

gamma_row =
  Support.input()
  |> Support.transpose()
  |> Enum.map(&Enum.frequencies/1)
  |> Enum.map(fn frequencies ->
    {k, _} = Enum.max_by(frequencies, fn {_, v} -> v end)
    k
  end)

epsilon_row = Enum.map(gamma_row, &Support.negate/1)
gamma = gamma_row |> Support.row_to_number()
epsilon = epsilon_row |> Support.row_to_number()

IO.inspect(gamma * epsilon, label: "Part 1")

oxigen_generator_rating =
  Support.input()
  |> Support.find_most_common(:gte)
  |> Support.row_to_number()

co2_scrubber_rating =
  Support.input()
  |> Support.find_most_common(:lte)
  |> Support.row_to_number()

IO.inspect(oxigen_generator_rating * co2_scrubber_rating, label: "Part 2")
