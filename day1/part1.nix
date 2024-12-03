let
  inherit (import <nixpkgs> {}) lib;

  list = let
    input = builtins.readFile ./input
      |> lib.strings.splitString "\n"
      |> map (lib.strings.splitString "   ")
      |> builtins.filter (x: (builtins.head x) != "" && (builtins.elemAt x 1) != "" );

    list1 = input
      |> map (x: x |> builtins.head |> lib.strings.toInt)
      |> lib.lists.sort (a: b: a < b);

    list2 = input
      |> map (x: builtins.elemAt x 1 |> lib.strings.toInt)
      |> lib.lists.sort (a: b: a < b);
  in
    lib.lists.imap0 (i: x: [x (builtins.elemAt list2 i)]) list1;

  distance = let
    diff = a: b:
      if a > b
      then a - b
      else b - a;
  in
    builtins.foldl' (acc: a: acc + diff (builtins.head a) (builtins.elemAt a 1)) 0 list;
in
  { inherit distance; }
