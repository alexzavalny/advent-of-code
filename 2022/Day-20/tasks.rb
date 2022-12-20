def solution(nums, coef = 1, cycles = 1)
  # [{ndx:0, val: 1}, {ndx: 1, val: 5},...]
  items = nums.map.with_index { |el, ndx| { ndx: ndx, val: el.to_i * coef } }

  cycles.times do
    nums.size.times do |ndx|
      before_ndx = items.find_index { |el| el[:ndx] == ndx }
      item = items.delete_at(before_ndx)
      after_ndx = (before_ndx + item[:val]) % items.size
      items.insert(after_ndx, item)
    end
  end

  zero_ndx = items.find_index { |el| el[:val] == 0 }

  [1000, 2000, 3000].sum do |offset| 
    items[(zero_ndx + offset) % nums.size][:val]
  end
end

numbers = File.readlines("input0.txt").map(&:to_i)
puts "Part1: ", solution(numbers)
puts "Part2: ", solution(numbers, 811589153, 10)
