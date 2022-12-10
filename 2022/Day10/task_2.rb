def solution(input)
  cycle = 0
  x = 1
  screen = Array.new(6) { Array.new(40) { '?' } }

  cor_x = 0
  cor_y = 0
  
  input.each do |inst|
    if inst == "noop"
      cycle += 1

      sign = (cor_x - x).abs < 2 ? "#" : "."
      screen[cor_y][cor_x] = sign

      cor_x += 1
      if cor_x % 40 == 0
        cor_y += 1
        cor_x = 0
      end


    else
      add_value = inst.split.last.to_i
      cycle += 1
      

      

      sign = (cor_x - x).abs < 2 ? "#" : "."
      screen[cor_y][cor_x] = sign
      cor_x += 1
      if cor_x % 40 == 0
        cor_y += 1
        cor_x = 0
      end


      cycle += 1


      

      sign = (cor_x - x).abs < 2 ? "#" : "."
      screen[cor_y][cor_x] = sign
      cor_x += 1
      if cor_x % 40 == 0
        cor_y += 1
        cor_x = 0
      end

      x += add_value
    end
  end

  puts screen.map(&:join)
end

solution(File.readlines("input1.txt", chomp: true))
#puts "13140"
#puts "-"
#puts solution(File.readlines("input1.txt", chomp: true))