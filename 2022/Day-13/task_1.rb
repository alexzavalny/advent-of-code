def right_order?(l, r, level) # -> true/false/nil
  puts "#{' ' * level}- Compare #{l} vs #{r}"

  if l.is_a?(Integer) && r.is_a?(Array)
    puts "#{' ' * level} - Mixed types; Converting left"
    l = [l] 
  end

  if l.is_a?(Array) && r.is_a?(Integer)
    puts "#{' ' * level} - Mixed types; Converting right"
    r = [r] 
  end

  if l.is_a?(Array) && r.is_a?(Array)
    l.each_with_index do |l_elem, index|
      if r.size <= index
        puts "#{' ' * level} - Right side ran out of items, so inputs are not in the right order"
        return false
      end
      r_o = right_order?(l[index], r[index], level+1)
      return true if r_o == true
      return false if r_o == false
    end
    if l.size < r.size
      puts "#{' ' * level} - Left side ran out of items, so inputs are in the right order"
      return true
    end
  else
    if l < r
      puts "#{' ' * level} - Left side is smaller, so inputs are  in the right order"
      return true 
    end
    if l > r
      puts "#{' ' * level} - Right side is smaller, so inputs are not in the right order"
      return false 
    end
    # if l == r
    #   puts "#{' ' * level} Left = Right, so cannot decide"
    #   return nil 
    # end
  end

  return nil
end

def solution(input)
  pairs = input.split("\n\n").map { |p| p.split("\n").map { |l_or_r| eval(l_or_r) } }
  #p pairs
  correct_indexes = []
  pairs.each_with_index do |pair, index|
    puts "=== Pair #{index+1} ==="
    correct_indexes << (index+1) if right_order?(pair[0], pair[1], 0)
    puts " "
  end
  p correct_indexes
  correct_indexes.sum
end

puts solution(File.read("input1.txt"))
