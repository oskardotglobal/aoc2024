open Batteries
open Printf

type facing = Left | Right | Up | Down
type guard = { mutable pos : int * int; mutable facing : facing }

let lines = File.lines_of "input2" |> List.of_enum
let visited : ((int * int) * facing) list ref = ref []
let guard = ref { pos = (0, 0); facing = Up }

let corner =
  ref (List.first lines |> String.trim |> String.length, List.length lines - 1)

let blockades = ref []

let readBlockades =
 fun () ->
  let f =
   fun y line ->
    List.iteri (fun x char ->
        match char with
        | '^' ->
            assert (!guard.pos == (0, 0));
            !guard.pos <- (x, y)
        | '#' -> blockades := (x, y) :: !blockades
        | _ -> ())
    @@ String.to_list line
  in
  List.iteri f lines

let moveGuard =
 fun () ->
  let isFacingBlockade =
   fun () ->
    let x, y = !guard.pos in
    match !guard.facing with
    | Up -> List.mem (x, y - 1) !blockades
    | Down -> List.mem (x, y + 1) !blockades
    | Left -> List.mem (x - 1, y) !blockades
    | Right -> List.mem (x + 1, y) !blockades
  in

  let moveGuardBy =
   fun (newX, newY) ->
    visited := (!guard.pos, !guard.facing) :: !visited;
    !guard.pos <- (newX, newY)
  in

  let isExited =
   fun () ->
    let x, y = !guard.pos in
    let maxX, maxY = !corner in
    x < 0 || y < 0 || x > maxX || y > maxY
  in

  let isLooping = fun () -> List.mem (!guard.pos, !guard.facing) !visited in

  while not (isExited () || isLooping ()) do
    let x, y = !guard.pos in

    match (!guard.facing, isFacingBlockade ()) with
    | Up, true -> !guard.facing <- Right
    | Down, true -> !guard.facing <- Left
    | Left, true -> !guard.facing <- Up
    | Right, true -> !guard.facing <- Down
    | Up, false -> moveGuardBy (x, y - 1)
    | Down, false -> moveGuardBy (x, y + 1)
    | Left, false -> moveGuardBy (x - 1, y)
    | Right, false -> moveGuardBy (x + 1, y)
  done;

  isLooping ()

let findLoops =
 fun () ->
  let initialBlockades =
    !guard.pos <- (0, 0);
    readBlockades ();
    !blockades
  in
  let initialVisited = !visited in
  List.map Tuple2.first initialVisited
  |> List.unique
  |> List.filter (fun coord ->
         !guard.pos <- (0, 0);
         blockades := coord :: initialBlockades;
         visited := [];

         moveGuard ())

let () =
  readBlockades ();
  assert (moveGuard () == false);

  List.map (fun (coords, _) -> coords) !visited
  |> List.unique |> List.length |> Int.to_string |> printf "Part 1: %s\n";

  findLoops () |> List.length |> Int.to_string |> printf "Part 2: %s\n"
