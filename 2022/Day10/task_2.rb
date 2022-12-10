def solution(input)
  x_register = 1
  screen = Array.new(6) { Array.new(40) { '?' } }
  cor_x, cor_y = 0, 0
  
  input.map(&:split).each do |command, value|
    cycles_per_command = {"noop" => 1, "addx" => 2}

    cycles_per_command[command].times do
      close_to_cursor = (cor_x - x_register).abs < 2 
      sign = close_to_cursor ? "#" : "."
      screen[cor_y][cor_x] = sign

      cor_x = (cor_x + 1) % 40
      cor_y += 1 if cor_x.zero?
    end

    x_register += value.to_i if command == "addx"
  end

  screen.map(&:join)
end

puts solution(File.readlines("input1.txt", chomp: true))
