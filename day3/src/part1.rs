use super::INPUT;
use regex::Regex;

const REGEX: &str = r"(?m)mul\((\d+),(\d+)\)";

pub fn part1() -> i64 {
    let regex = Regex::new(REGEX).unwrap();

    regex
        .captures_iter(INPUT)
        .map(|c| c.extract())
        .map(|(_, [a, b])| a.parse::<i64>().unwrap() * b.parse::<i64>().unwrap())
        .sum::<i64>()
}
