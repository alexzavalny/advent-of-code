def right_order?(l, r) 
  return r <=> l if [l, r].all? { _1.is_a?(Integer) }

  l = [l] if l.is_a?(Integer) && r.is_a?(Array)
  r = [r] if l.is_a?(Array) && r.is_a?(Integer)

  l.each_with_index do |_, index|
    break if r.size <= index
    r_o = right_order?(l[index], r[index])
    return r_o unless r_o.zero?
  end

  return r.size <=> l.size
end

def solution1(input)
  pairs = input.split("\n\n").map { |p| p.split("\n").map { |line| eval(line) } }
  correct_indexes = []
  pairs.each_with_index do |pair, index|
    correct_indexes << (index+1) if right_order?(pair[0], pair[1]) == 1
  end
  correct_indexes.sum
end

def solution2(input)
  packets = input.split("\n").filter { |p| p != "" }.map { |packet| eval(packet) }
  packets << [[2]] << [[6]]
  sorted = packets.sort { |a, b| -right_order?(a, b) }
  return (sorted.index([[2]]) + 1) * (sorted.index([[6]]) + 1)
end

puts solution1(File.read("input0.txt"))
puts solution2(File.read("input0.txt"))
puts solution1(File.read("input1.txt"))
puts solution2(File.read("input1.txt"))
