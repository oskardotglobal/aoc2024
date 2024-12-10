{:ok, contents} = File.read("input")

defmodule Main do
  def sorted(report) do
    Enum.sort(report, :asc) === report or
      Enum.sort(report, :desc) === report
  end

  def no_duplicates(report) do
    Enum.uniq(report) === report
  end

  def level_diff_ok_filter?(report, {level, 0}) do
    right = Enum.fetch!(report, 1)
    diffRight = abs(right - level)

    Enum.all?([
      diffRight >= 1 and diffRight <= 3,
      right !== level
    ])
  end

  def level_diff_ok_filter?(report, {level, index}) when index == length(report) - 1 do
    left = Enum.fetch!(report, index - 1)
    diffLeft = abs(left - level)

    Enum.all?([
      diffLeft >= 1 and diffLeft <= 3,
      left !== level
    ])
  end

  def level_diff_ok_filter?(report, {level, index}) do
    left = Enum.fetch!(report, index - 1)
    right = Enum.fetch!(report, index + 1)
    diffLeft = abs(left - level)
    diffRight = abs(right - level)

    Enum.all?([
      diffLeft >= 1 and diffLeft <= 3,
      diffRight >= 1 and diffRight <= 3,
      left !== level,
      right !== level,
      left !== right
    ])
  end

  def level_diff_ok([]), do: false
  def level_diff_ok([_]), do: true

  def level_diff_ok(report) do
    f = fn x -> level_diff_ok_filter?(report, x) end
    Enum.with_index(report) |> Enum.all?(f)
  end

  def report_ok(report) do
    sorted(report) and
      no_duplicates(report) and
      level_diff_ok(report)
  end
end

input =
  contents
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end)

part1 =
  input
  |> Enum.filter(&Main.report_ok/1)
  |> length

part2 =
  input
  |> Enum.filter(fn report ->
    f = fn {_, index} -> List.delete_at(report, index) |> Main.report_ok() end
    Main.report_ok(report) or Enum.with_index(report) |> Enum.any?(f)
  end)
  |> length

IO.puts("Part 1: #{part1}")
IO.puts("Part 2: #{part2}")
