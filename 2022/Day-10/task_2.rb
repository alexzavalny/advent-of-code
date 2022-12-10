def solution(input)
  x_register = 1
  screen = Array.new(6) { Array.new(40) { "" } }
  
  input
    .map { _1.split[1] }
    .reduce([]) { |acc, ins| acc << 0; acc << ins if ins; acc }
    .map
    .with_index(0) do |value, i|
      close_to_cursor = (i % 40 - x_register).abs <= 1 
      sign = close_to_cursor ? "#" : "."
      screen[i / 40][i % 40] = sign
      x_register += value.to_i 
    end

  screen.map(&:join)
end

puts solution(File.readlines("input1.txt", chomp: true))
