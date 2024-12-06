let
  pkgs = import <nixpkgs> { };
  inherit (pkgs) lib;
  inherit (lib) strings lists;

  # unzip : int -> list -> list
  # Turn a list of n-dimensional tuples into a tuple of n-dimensional lists
  # Note: Assumes that the input lists contains only tuples of the specified length (depth)
  #
  # Example:
  # > unzip 2 [[1 2] [3 4] [5 6] [7 8]]
  # [
  #   [1 3 5 7]
  #   [2 4 6 8]
  # ]
  unzip =
    depth: list:
    let
      lengthL = list |> builtins.length |> (x: x - 1) |> lists.range 0;
      depthL = lists.range 0 (depth - 1);

      f =
        depth:
        builtins.foldl' (acc: i: acc ++ [ (builtins.elemAt (builtins.elemAt list i) depth) ]) [ ] lengthL;
    in
    map f depthL;

  # zip : int -> list -> list
  # Turn a tuple of n-dimensional lists into a list of n-dimensional tuples
  # Note: Assumes that all lists in the input tuple have the same length
  #       (or at least the first n ones where n = depth).
  #
  # Example:
  # > zip 2 [[1 3 5 7] [2 4 6 8]]
  # [
  #   [1 2]
  #   [3 4]
  #   [5 6]
  #   [7 8]
  # ]
  zip =
    depth: tuple:
    let
      lengthL = tuple |> builtins.head |> builtins.length |> (x: x - 1) |> lists.range 0;
      depthL = lists.range 0 (depth - 1);

      f =
        i:
        builtins.foldl' (acc: depth: acc ++ [ (builtins.elemAt (builtins.elemAt tuple depth) i) ]) [
        ] depthL;
    in
    map f lengthL;

  # findCount : any -> list -> int
  # Find how often the first argument is found in the list. Return 0 if not found.
  findCount =
    x: list:
    if builtins.elem x list then
      builtins.foldl' (acc: y: (if x == y then acc + 1 else acc)) 0 list
    else
      0;

  input =
    builtins.readFile ./input
    |> strings.splitString "\n"
    |> map (strings.splitString "   ")
    |> lists.filter (builtins.all (v: v != ""))

    |> unzip 2
    |> map (list: list |> map strings.toInt |> lists.sort (a: b: a < b));

  distance =
    let
      diff =
        x:
        let
          a = builtins.head x;
          b = builtins.elemAt x 1;
        in
        if a > b then a - b else b - a;
    in
    zip 2 input |> builtins.foldl' (acc: x: acc + diff x) 0;

  similarity =
    let
      list = input |> unzip 2;

      left = builtins.head input;
      right = builtins.elemAt input 1;
    in
    builtins.foldl' (acc: x: acc + x * (findCount x right)) 0 left;
in
{
  inherit
    similarity
    distance
    zip
    unzip
    ;
}
