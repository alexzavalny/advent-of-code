def right_order?(l, r, level) # -> true/false/nil
  puts "#{' ' * level}Compare #{l} vs #{r}"

  return false if r.nil?

  if l.is_a?(Integer) && r.is_a?(Array)
    puts "#{' ' * level} Converting left"
    l = [l] 
  end

  if l.is_a?(Array) && r.is_a?(Integer)
    puts "#{' ' * level} Converting right"
    r = [r] 
  end

  if l.is_a?(Array) && r.is_a?(Array)
    l.each_with_index do |l_elem, index|
      r_o = right_order?(l[index], r[index], level+1)
      return true if r_o == true
      return false if r_o == false
    end
  else
    if l < r
      puts "#{' ' * level} Left is smaller, so they are in right order"
      return true 
    end
    if l < r
      puts "#{' ' * level} Left is highter, so they are in wrong order"
      return false 
    end
    if l == r
      puts "#{' ' * level} Left = Right, so cannot decide"
      return nil 
    end
  end

  return false
end

def solution(input)
  pairs = input.split("\n\n").map { |p| p.split("\n").map { |l_or_r| eval(l_or_r) } }
  #p pairs
  correct_indexes = []
  pairs.each_with_index do |pair, index|
    correct_indexes << (index+1) if right_order?(pair[0], pair[1], 0)
    puts " "
  end
  correct_indexes.sum
end

puts solution(File.read("input1.txt"))
