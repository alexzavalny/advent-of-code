numbers = File.readlines("input1.txt").map(&:to_i)
elements = []
numbers.each_with_index { |el, ndx| elements << { ndx: ndx, value: el.to_i } }

count = numbers.size
count.times do |ndx|
  found_ndx = elements.find_index { _1[:ndx] == ndx }
  el = elements[found_ndx] 

  elements.delete_at(found_ndx)
  new_ndx = found_ndx + el[:value]
  while new_ndx < 0 || new_ndx >= count
    new_ndx %= (count - 1)
  end

  # for some reason, element gets to the end, not to the start
  new_ndx = count - 1 if new_ndx == 0

  elements.insert(new_ndx, el)
end

zero_pos = elements.find_index { _1[:value] == 0 }
p_1000 = zero_pos + 1000
p_2000 = zero_pos + 2000
p_3000 = zero_pos + 3000

puts elements[p_1000 % count][:value] + 
     elements[p_2000 % count][:value] + 
     elements[p_3000 % count][:value]
