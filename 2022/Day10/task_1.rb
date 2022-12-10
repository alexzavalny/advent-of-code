def solution(input)
  cycle, signals = 0, 0
  x_register = 1

  input.map(&:split).each do |command, value|
    cycles_per_command = {"noop" => 1, "addx" => 2}

    cycles_per_command[command].times do
      cycle += 1
      good_cycle = (cycle - 20) % 40 == 0
      signals += (x_register*cycle) if good_cycle
    end
  
    x_register += value.to_i if command == "addx"
  end

  signals
end

puts solution(File.readlines("input0.txt", chomp: true))
puts solution(File.readlines("input1.txt", chomp: true))