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
  pairs = input.split("\n\n").map { |p| p.split("\n").map { |l_or_r| eval(l_or_r) } }
  correct_indexes = []
  pairs.each_with_index do |pair, index|
    correct_indexes << (index+1) if right_order?(pair[0], pair[1], 0) == 1
  end
  correct_indexes.sum
end

puts solution(File.read("input1.txt"))
