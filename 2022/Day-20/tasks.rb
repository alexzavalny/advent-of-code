def solution(numbers, coef = 1, cycles = 1)
  # storing not only numbers but initial indexes
  elements = numbers.map.with_index { |el, ndx| { ndx: ndx, val: el.to_i * coef } }

  cycles.times do
    numbers.size.times do |ndx|
      before_index = elements.find_index { _1[:ndx] == ndx }
      element = elements[before_index]

      elements.delete_at(before_index)

      after_index = (before_index + element[:val]) % elements.size
      elements.insert(after_index, element)
    end
  end

  zero_pos = elements.find_index { _1[:val] == 0 }

  [1000, 2000, 3000].sum do |position| 
    circle_position = (zero_pos + position) % numbers.size
    elements[circle_position][:val]
  end
end

require 'benchmark'

puts Benchmark.measure {
  numbers = File.readlines("input1.txt").map(&:to_i)
  puts "Part1: #{ solution(numbers) }"
  puts "Part2: #{ solution(numbers, 811589153, 10) }"
}
