use regex::Regex;

const REGEX: &str = r"(?m)mul\((\d+),(\d+)\)";
const INPUT: &str = include_str!("input");

fn main() {
    assert!(INPUT != "");

    let regex = Regex::new(REGEX).unwrap();
}
