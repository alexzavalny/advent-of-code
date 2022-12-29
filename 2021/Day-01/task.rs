use std::fs;

fn solution1(input: &String) {
    let mut times_increased = 0;
    let mut prev = 0;
    for line in input.lines() {
        let number = line.parse::<i32>().unwrap();
        if number > prev && prev != 0 {
            times_increased += 1;
        }
        prev = number;
    }
    println!("Solution 1: {}", times_increased);
}

fn solution2(input: &String) {
    let mut times_increased = 0;
    let mut prev_sum = 0;
    let parsed_numbers = input.lines()
        .map(|s| s.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();

    for elements in parsed_numbers.windows(3) {
        if prev_sum > 0 {
            if elements.iter().sum::<i32>() > prev_sum {
                times_increased += 1;
            }
        }
        prev_sum = elements.iter().sum::<i32>();
    }
    println!("Solution 2: {}", times_increased);
}

fn main() {
    let input = fs::read_to_string("input1.txt").unwrap();
    solution1(&input);
    solution2(&input);
}