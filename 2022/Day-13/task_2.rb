def right_order?(l, r, level) 
  l = [l] if l.is_a?(Integer) && r.is_a?(Array)
  r = [r] if l.is_a?(Array) && r.is_a?(Integer)

  if l.is_a?(Array) && r.is_a?(Array)
    l.each_with_index do |l_elem, index|
      return -1 if r.size <= index
      r_o = right_order?(l[index], r[index], level+1)
      return 1 if r_o == 1
      return -1 if r_o == -1
    end
    return 1 if l.size < r.size
  else
    return 1 if l < r
    return -1 if l > r
  end

  return 0
end

def solution(input)
  packets = input.filter { |p| p != "" }.map { |packet| eval(packet) }
  packets << [[2]] << [[6]]
  sorted = packets.sort { |a, b| -right_order?(a, b, 0) }
  return (sorted.index([[2]]) + 1) * (sorted.index([[6]]) + 1)
end

puts solution(File.readlines("input1.txt", chomp: true))
