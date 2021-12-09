defmodule Day09 do
  def run() do
    matrix = input()
    rows_count = tuple_size(matrix)
    columns_count = tuple_size(elem(matrix, 0))

    result =
      for row <- 0..(rows_count - 1),
          col <- 0..(columns_count - 1),
          current_value = get_value(matrix, {row, col}),
          lower_point?(matrix, current_value, {row, col}) do
        current_value + 1
      end
      |> Enum.sum()

    IO.inspect(result, label: "Part 1")

    all_basin_points =
      for row <- 0..(rows_count - 1),
          col <- 0..(columns_count - 1),
          current_value = get_value(matrix, {row, col}),
          current_value < 9 do
        {row, col}
      end

    result =
      assign_all_points(all_basin_points, matrix, [])
      |> Enum.map(&length(&1))
      |> Enum.sort(:desc)
      |> Enum.take(3)
      |> Enum.reduce(1, fn v, acc -> v * acc end)

    IO.inspect(result, label: "Part 2")
  end

  defp find_same_basin(_matrix, [], already_visited) do
    already_visited
  end

  defp find_same_basin(matrix, [point | rest], already_visited) do
    points_to_check =
      matrix
      |> get_sorrownding(point)
      |> Enum.reject(fn {_, v} -> v == 9 end)
      |> Enum.reject(fn {p, _} -> p in already_visited end)
      |> Enum.map(fn {p, _} -> p end)

    find_same_basin(matrix, Enum.uniq(rest ++ points_to_check), [point | already_visited])
  end

  defp assign_all_points([], _matrix, groups) do
    groups
  end

  defp assign_all_points([point | rest], matrix, groups) do
    same_basin = find_same_basin(matrix, [point], [])
    new_rest = rest -- same_basin
    assign_all_points(new_rest, matrix, [same_basin | groups])
  end

  defp lower_point?(matrix, current_value, point) do
    sorrowndings = get_sorrownding(matrix, point)
    Enum.all?(sorrowndings, fn {_, v} -> current_value < v end)
  end

  defp get_value(matrix, {row, col}) do
    matrix |> elem(row) |> elem(col)
  end

  defp get_sorrownding(matrix, {row, col}) do
    rows_count = tuple_size(matrix)
    columns_count = tuple_size(elem(matrix, 0))

    [
      {row + 1, col},
      {row - 1, col},
      {row, col + 1},
      {row, col - 1}
    ]
    |> Enum.filter(fn {row, col} ->
      row >= 0 && row < rows_count && col >= 0 and col < columns_count
    end)
    |> Enum.map(fn point -> {point, get_value(matrix, point)} end)
  end

  defp input() do
    File.read!("day_9.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> List.to_tuple()
  end
end

Day09.run()
