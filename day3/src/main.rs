#![feature(decl_macro)]

mod part1;
mod part2;

use part1::part1;
use part2::part2;

pub(crate) const INPUT: &str = include_str!("input");

fn main() {
    println!("Part 2: {} (last: 102873763)", part2());
    println!("Part 1: {}", part1());
}
