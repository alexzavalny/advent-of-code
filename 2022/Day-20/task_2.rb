numbers = File.readlines("input1.txt").map(&:to_i)

elements = []

numbers.each_with_index do |el, ndx|
  elements << { ndx: ndx, value: el.to_i * 811589153}
end

def print(shit)
  p shit.map { _1[:value] }
end

#print(elements)

count = numbers.size

10.times do |round|
  count.times do |ndx|
    #find element
    found_ndx = elements.find_index { |x| x[:ndx] == ndx }
    el = elements[found_ndx] 

    elements.delete_at(found_ndx)
    new_ndx = found_ndx + el[:value]
    while new_ndx < 0
      #new_ndx += count - 1
      new_ndx %= (count - 1)
    end

    while new_ndx >= count
      new_ndx %= (count - 1) #new_ndx - count + 1
    end
    new_ndx = count - 1 if new_ndx == 0
    #puts "Will move #{el[:value]} from ndx #{found_ndx} to ndx #{new_ndx}"

    elements.insert(new_ndx, el)


  end

  #puts "After #{round} round of mixing"
#  print(elements)
  #gets
end

zero_pos = elements.find_index { |x| x[:value] == 0 }
p zero_pos
p_1000 = zero_pos + 1000
p_2000 = zero_pos + 2000
p_3000 = zero_pos + 3000
puts elements[p_1000 % count]
puts elements[p_2000 % count]
puts elements[p_3000 % count]

puts elements[p_1000 % count][:value] + elements[p_2000 % count][:value] + elements[p_3000 % count][:value]
#p numbers.size
#p numbers.uniq.size
#p numbers