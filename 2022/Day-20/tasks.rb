def solution(filename, coef = 1, cycles = 1)
  numbers = File.readlines(filename).map(&:to_i)
  count = numbers.size

  # storing not only numbers but initial indexes
  elements = numbers.map.with_index { |el, ndx| { ndx: ndx, val: el.to_i * coef } }

  cycles.times do
    # we go through all numbers
    count.times do |ndx|
      # find
      before_index = elements.find_index { _1[:ndx] == ndx }
      element = elements[before_index]

      # remove element from the list
      elements.delete_at(before_index)

      # reinsert at new index
      after_index = (before_index + element[:val]) % (count - 1)
      elements.insert(after_index, element)
    end
  end

  zero_pos = elements.find_index { _1[:val] == 0 }

  [1000, 2000, 3000].sum do |position| 
    elements[(zero_pos + position) % count][:val]
  end
end

require 'benchmark'

puts Benchmark.measure {
  puts "Part1: #{ solution("input1.txt") }"
  puts "Part2: #{ solution("input1.txt", 811589153, 10) }"
}