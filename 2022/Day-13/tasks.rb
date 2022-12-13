def right_order?(l, r) 
  return l <=> r if [l, r].all? { _1.is_a?(Integer) }

  l, r = Array(l), Array(r)

  l.each_with_index do |_, index|
    break if r.size <= index
    r_o = right_order?(l[index], r[index])
    return r_o unless r_o.zero?
  end

  return l.size <=> r.size
end

def solution1(input)
  input
    .split("\n\n")
    .map { |p| p.split("\n").map { |line| eval(line) } }
    .each_with_index
    .reduce(0) do |sum, ((l, r), index)|
      right_order?(l, r).zero? ? sum : sum + index + 1
    end
end

def solution2(input)
  packets = input.split("\n").filter { |p| p != "" }.map { |packet| eval(packet) }
  packets << [[2]] << [[6]]
  sorted = packets.sort { |a, b| right_order?(a, b) }
  return (sorted.index([[2]]) + 1) * (sorted.index([[6]]) + 1)
end

puts solution1(File.read("input0.txt"))
puts solution2(File.read("input0.txt"))
puts solution1(File.read("input1.txt"))
puts solution2(File.read("input1.txt"))