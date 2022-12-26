require '../../aoc_utils'

x, y = 0, 0

input_lines.each do |line|
  direction, steps = line.split(' ')
  steps = steps.to_i
  case direction
  when 'forward'
    x += steps
  when 'down'
    y += steps
  when 'up'
    y -= steps
  end
end

puts "Solution 1: #{x * y}"

x, y, aim = 0, 0, 0
input_lines.each do |line|
  direction, steps = line.split(' ')
  steps = steps.to_i
  case direction
  when 'forward'
    x += steps
    y += aim * steps
  when 'down'
    aim += steps
  when 'up'
    aim -= steps
  end
end

puts "Solution 2: #{x * y}"