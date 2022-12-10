def solution(input)
  cycle = 0
  x = 1
  signals = 0

  good_cycle = -> (c) { (c - 20) % 40 == 0}

  input.each do |inst|
    if inst == "noop"
      cycle += 1
      signals += (x*cycle) if good_cycle.(cycle)
      puts x if good_cycle.(cycle)
      #puts "Cycle: #{cycle}, X: #{x}"
    else
      add_value = inst.split.last.to_i
      #puts "addx #{add_value}"
      cycle += 1
      signals += (x*cycle) if good_cycle.(cycle)
      
      puts x if good_cycle.(cycle)
      #puts "Cycle: #{cycle}, X: #{x}"
      cycle += 1

      puts x if good_cycle.(cycle)
      signals += (x*cycle) if good_cycle.(cycle)
      x += add_value
      #puts "Cycle: #{cycle}, X: #{x}"
      #puts x if good_cycle.(cycle)
      
    end
  end

  puts "----"
  signals
end

puts solution(File.readlines("input0.txt", chomp: true))
puts "13140"
puts "-"
puts solution(File.readlines("input1.txt", chomp: true))