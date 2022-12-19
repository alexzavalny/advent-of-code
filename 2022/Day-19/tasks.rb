require 'set'
require 'benchmark'

def process(time_total, ore_robot_ore_price, cla_robot_ore_price, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price)
  max_geo = 0
  state = [0, 0, 0, 0, 1, 0, 0, 0, time_total] #only have 1 ore robot 
  states = [state]
  visited = Set[]
  max_ore_price = [ore_robot_ore_price, cla_robot_ore_price, obs_robot_ore_price, geo_robot_ore_price].max

  while states.size > 0
    state = states.shift
    ore, cla, obs, geo, ore_robots, cla_robots, obs_robots, geo_robots, time_left = state

    # NEXT LINE STOLEN FROM REDDIT AFTER GOLD STAR. But it works very fast only for input, not correct for test. :-)
    # LEAVING THIS FOR FUTURE REFERENCE
    next if geo + geo_robots + time_left < max_geo
    max_geo = [max_geo, geo + geo_robots].max

    next if time_left == 1
    new_time_left = time_left - 1

    #magical optimization, cutting down ore money if we are unable to spend it, which will reduce state count
    ore = [ore, time_left * max_ore_price - ore_robots * new_time_left].min
    #todo: same for all other currencies.

    state = [ore, cla, obs, geo, ore_robots, cla_robots, obs_robots, geo_robots]

    next if visited.include?(state)
    visited << state

    # if you can buy geo robot, then do it and don't add any other chances
    if ore >= geo_robot_ore_price and obs >= geo_robot_cla_price # buy geo unit
      states.prepend([ # PREPEND NEXT STOLEN FROM REDDIT AFTER GOLD STAR
        ore + ore_robots - geo_robot_ore_price, 
        cla + cla_robots, 
        obs + obs_robots - geo_robot_cla_price, 
        geo + geo_robots, 
        ore_robots, cla_robots, 
        obs_robots, 
        geo_robots + 1, 
        new_time_left
      ])

      next
    end

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

  end

  max_geo
end

def solution1(input)
  input.sum do |line|
    numbers = line.scan(/\d+/).map(&:to_i)
    blueprint_id, ore_cost, cla_cost, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price = numbers
    puts "Processing #{blueprint_id}"
    rez = process(24, ore_cost, cla_cost, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price)
    rez * blueprint_id
  end
end

def solution2(input)
  geods = []
  input[0..2].each do |line|
    numbers = line.scan(/\d+/).map(&:to_i)
    blueprint_id, ore_cost, cla_cost, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price = numbers
    puts "Processing #{blueprint_id}"
    rez = process(32, ore_cost, cla_cost, obs_robot_ore_price, obs_robot_cla_price, geo_robot_ore_price, geo_robot_cla_price)
    geods << rez
  end
  p geods
  geods.reduce(:*)
end

puts Benchmark.measure { puts solution1(File.readlines("input1.txt")) }
