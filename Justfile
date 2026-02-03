# Format all code
fmt:
    nix run nixpkgs#nixfmt-rfc-style day1/default.nix
    mix format day2/*.exs
    cargo fmt --manifest-path ./day3/Cargo.toml

# Run all code
run:
    nix-instantiate --eval day1
    pushd day2 && elixir main.exs && popd
    cargo run --manifest-path ./day3/Cargo.toml
