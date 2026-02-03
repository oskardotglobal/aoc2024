use std::str::Chars;

use super::INPUT;

#[derive(Debug)]
enum Tokens {
    Do,
    Dont,
    Mul(i64, i64),
}

struct Scanner<'a> {
    buffer: &'a mut Chars<'a>,
    discarded: Vec<char>,
    eof: bool,
}

macro expect($self:expr, $expected:expr) {
    match $self.read() {
        Some(char) if char == $expected => (),
        Some(char) => {
            $self.discarded.push(char);
            return None;
        }
        None => return None,
    }
}

macro expect_many($self:expr, $expected:expr) {
    if $self.read_many($expected.len()) != $expected {
        $self.discarded.extend($expected);
        return None;
    }
}

impl<'a> Scanner<'a> {
    pub fn new(buffer: &'a mut Chars<'a>) -> Self {
        Self {
            buffer,
            eof: false,
            discarded: Vec::new(),
        }
    }

    fn read(&mut self) -> Option<char> {
        let char = self.buffer.next();

        if char.is_none() {
            self.eof = true;
        }

        char
    }

    fn read_many(&mut self, n: usize) -> Vec<char> {
        let chars: Vec<char> = self.buffer.take(n).collect();

        if chars.len() != n {
            self.eof = true;
        }

        chars
    }

    fn scan_digits(&mut self, first: bool) -> Option<i64> {
        let mut chars = String::new();

        for _ in 0..5 {
            match self.read() {
                Some(c) if c.is_ascii_digit() => chars.push(c),
                Some(',') if first => break,
                Some(')') => break,
                Some(c) => {
                    self.discarded.push(c);
                    return None;
                }
                None => return None,
            }
        }

        Some(chars.parse::<i64>().unwrap())
    }

    fn scan_mul(&mut self) -> Option<Tokens> {
        // 'm' is already consumed
        expect_many!(self, vec!['u', 'l', '(']);

        let first = self.scan_digits(true);
        let second = self.scan_digits(false);

        if let (Some(first), Some(second)) = (first, second) {
            return Some(Tokens::Mul(first, second));
        }

        None
    }

    fn scan_mode(&mut self) -> Option<Tokens> {
        // 'd' is already consumed
        expect!(self, 'o');

        match self.read() {
            Some('(') => {
                expect!(self, ')');
                Some(Tokens::Do)
            }
            Some('n') => {
                expect_many!(self, vec!['\'', 't', '(', ')']);
                Some(Tokens::Dont)
            }
            Some(c) => {
                self.discarded.push(c);
                None
            }
            None => None,
        }
    }

    pub fn scan(&mut self) -> Vec<Tokens> {
        let mut result = Vec::new();

        while !self.eof {
            if let Some(token) = match self.read() {
                Some('m') => self.scan_mul(),
                Some('d') => self.scan_mode(),
                Some(char) => {
                    self.discarded.push(char);
                    None
                }
                None => None,
            } {
                result.push(token);
            }
        }

        // println!("{}", self.discarded.iter().collect::<String>());

        result
    }
}

pub fn part2() -> i64 {
    let mut chars = INPUT.chars();
    let mut scanner = Scanner::new(&mut chars);
    let tokens = scanner.scan();

    let mut enabled = true;

    tokens
        .iter()
        .filter_map(|token| match (token, enabled) {
            (Tokens::Mul(a, b), _) => Some(a * b),
            (Tokens::Do, false) => {
                enabled = true;
                None
            }
            (Tokens::Dont, true) => {
                enabled = false;
                None
            }
            _ => None,
        })
        .sum()
}
