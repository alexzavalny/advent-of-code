# The trick I use here is in the reduce function
# Turns out if you replace prepend addx 0 before each addx, you can ignore cycles
# and if you replace noop with add x, then you can ignore command names (all will be addx)

def solution(input)
  x_register = 1

  input
    .map(&:split)
    .reduce([]) { |acc, ins| acc << ["addx", 0]; acc << ins if ins[1]; acc }
    .map
    .with_index(1) do |command, i|
      signal = x_register * i
      x_register += command.last.to_i
      (i - 20) % 40 == 0 ? signal : 0
    end
    .sum
end

puts solution(File.readlines("input0.txt", chomp: true))
puts solution(File.readlines("input1.txt", chomp: true))