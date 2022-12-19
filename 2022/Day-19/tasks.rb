require 'set'
require 'benchmark'

def process(time_total, ore_robot_ore_price, cla_robot_ore_price, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price)
  best = 0
  state = [0, 0, 0, 0, 1, 0, 0, 0, time_total]
  states = [state]
  visited = Set[]

  while states.size > 0
    state = states.shift
    ore, cla, obs, geo, ore_robots, cla_robots, obs_robots, geo_robots, time_left = state
  
    best = [best, geo].max

    next if time_left == 0
    new_time_left = time_left - 1

    max_ore_price = [ore_robot_ore_price, cla_robot_ore_price, obs_robot_ore_price, geo_robot_ore_price].max
    ore = [ore, time_left * max_ore_price - ore_robots * new_time_left].min

    state = [ore, cla, obs, geo, ore_robots, cla_robots, obs_robots, geo_robots, time_left]

    next if visited.include?(state)
    visited << state

    #don't buy anything, otherwise will kill ways to buy something more expensive
    states << [
      ore + ore_robots,
      cla + cla_robots,
      obs + obs_robots,
      geo + geo_robots,
      ore_robots,
      cla_robots,
      obs_robots,
      geo_robots,
      new_time_left
    ]

    #have enough to buy ore
    if ore >= ore_robot_ore_price # buy ore robot
      states << [
        ore + ore_robots - ore_robot_ore_price, 
        cla + cla_robots, 
        obs + obs_robots,
        geo + geo_robots, 
        ore_robots + 1,
        cla_robots,
        obs_robots,
        geo_robots, 
        new_time_left
      ]
    end

    #have enough to buy clay
    if ore >= cla_robot_ore_price # buy clay robot
      states << [
        ore + ore_robots - cla_robot_ore_price,
        cla + cla_robots,
        obs + obs_robots,
        geo + geo_robots,
        ore_robots,
        cla_robots + 1,
        obs_robots,
        geo_robots,
        new_time_left
      ]
    end

    #have enough to buy obsid
    if ore >= obs_robot_ore_price and cla >= obs_robot_cla_price # buy obsidian robot
      states << [
        ore + ore_robots - obs_robot_ore_price,
        cla + cla_robots - obs_robot_cla_price, 
        obs + obs_robots, 
        geo + geo_robots, 
        ore_robots,
        cla_robots,
        obs_robots + 1,
        geo_robots, 
        new_time_left
      ]
    end
  
    if ore >= geo_robot_ore_price and obs >= geo_robot_cla_price # buy geo unit
      states << [
        ore + ore_robots - geo_robot_ore_price, 
        cla + cla_robots, 
        obs + obs_robots - geo_robot_cla_price, 
        geo + geo_robots, 
        ore_robots, cla_robots, 
        obs_robots, 
        geo_robots + 1, 
        new_time_left
      ]
    end
  end

  best
end


def solution1(input)
  sum = 0

  input.each do |line|
    numbers = line.scan(/\d+/).map(&:to_i)
    blueprint_id, ore_cost, cla_cost, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price = numbers
    puts "Processing #{blueprint_id}"
    rez = process(24, ore_cost, cla_cost, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price)
    sum += rez * blueprint_id
  end

  sum
end

def solution2(input)
  geods = []

  input.each do |line|
    numbers = line.scan(/\d+/).map(&:to_i)
    blueprint_id, ore_cost, cla_cost, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price = numbers
    puts "Processing #{blueprint_id}"
    rez = process(32, ore_cost, cla_cost, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price)
    geods << rez
  end

  geods.reduce(:*)
end

puts Benchmark.measure { puts solution1(File.readlines("input1.txt")) }
