use std::fs;

enum Direction {
    Forward,
    Down,
    Up,
}

struct Pair { 
    direction: Direction,
    steps: i32 
}

fn prepare_pairs(input: &String) -> Vec<Pair> {
    let mut pairs = Vec::new();

    for line in input.lines() {
        let mut parts = line.split_whitespace();
        let direction = parts.next();
        let direction = match direction.unwrap() {
            "forward" => Direction::Forward,
            "down" => Direction::Down,
            "up" => Direction::Up,
            _ => panic!("Unknown direction"),
        };
        let steps = parts.next();
        let steps = steps.unwrap().parse::<i32>().unwrap();
        pairs.push(Pair { direction, steps });
    }

    pairs
}

fn solution1(input: &String) {
    let pairs = prepare_pairs(input);
    let mut x = 0;
    let mut y = 0;

    for pair in pairs {
        match pair.direction {
            Direction::Forward => x += pair.steps,
            Direction::Down => y += pair.steps,
            Direction::Up => y -= pair.steps
        }
    }

    println!("Solution 1: {}", x * y);
}

fn solution2(input: &String) {
    let mut x = 0;
    let mut y = 0;
    let mut aim = 0;

    let pairs = prepare_pairs(input);

    for pair in pairs {
        match pair.direction {
            Direction::Forward => {
                x += pair.steps;
                y += aim * pair.steps;
            }
            Direction::Down => aim += pair.steps,
            Direction::Up => aim -= pair.steps
        }
    }

    println!("Solution 2: {}", x * y);
}

fn main() {
    let input = fs::read_to_string("input1.txt").unwrap();
    solution1(&input);
    solution2(&input);
}