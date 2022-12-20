use std::time::{Instant};

fn solution(nums: Vec<i64>, coef: i64, cycles: i64) -> i64 {
    let mut items = nums.iter().enumerate().map(|(ndx, val)| (ndx, val * coef)).collect::<Vec<_>>();

    for _ in 0..cycles {
        for ndx in 0..nums.len() {
            let before_ndx = items
                .iter()
                .position(|(ndx_item, _)| *ndx_item == ndx)
                .unwrap();

            let item = items.remove(before_ndx);
            let mut after_ndx = (before_ndx as i64 + item.1) % items.len() as i64;
            if after_ndx < 0 {
                after_ndx += items.len() as i64;
            }
            items.insert(after_ndx as usize, item);
        }
    }

    let zero_ndx = items.iter().position(|(_, val)| *val == 0).unwrap();
    let coords = [1000, 2000, 3000];
    coords.iter().map(|coord| items[((zero_ndx as i64 + coord) % nums.len() as i64) as usize].1).sum()
}

fn main() {
    let numbers = std::fs::read_to_string("input1.txt")
        .unwrap()
        .lines()
        .map(|line| line.parse::<i64>().unwrap())
        .collect::<Vec<_>>();   

    let start = Instant::now();
    println!("Part1: {}", solution(numbers.clone(), 1, 1));
    println!("Part2: {}", solution(numbers, 811589153, 10));
    let duration = start.elapsed();

    println!("Time elapsed in expensive_function() is: {:?}", duration);
}
