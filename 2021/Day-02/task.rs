use std::fs;

fn solution1(input: &String) {
    let input_lines = input.lines().collect::<Vec<&str>>();

    let mut x = 0;
    let mut y = 0;

    for line in input_lines {
        let parts: Vec<&str> = line.split(" ").collect();
        let direction = parts[0];
        let steps: i32 = parts[1].parse().unwrap();

        match direction {
            "forward" => x += steps,
            "down" => y += steps,
            "up" => y -= steps,
            _ => (),
        }
    }

    println!("Solution 1: {}", x * y);
}

fn solution2(input: &String) {
    let mut x = 0;
    let mut y = 0;
    let mut aim = 0;

    for line in input.lines() {
        let parts: Vec<&str> = line.split(" ").collect();
        let direction = parts[0];
        let steps: i32 = parts[1].parse().unwrap();

        match direction {
            "forward" => {
                x += steps;
                y += aim * steps;
            }
            "down" => aim += steps,
            "up" => aim -= steps,
            _ => (),
        }
    }

    println!("Solution 2: {}", x * y);
}

fn main() {
    let input = fs::read_to_string("input1.txt").unwrap();
    solution1(&input);
    solution2(&input);
}