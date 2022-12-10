# The trick I use here is in the reduce function
# Turns out if you replace prepend addx 0 before each addx, you can ignore cycles
# and if you replace noop with add x, then you can ignore command names (all will be addx)
# so I keep only values of addx (0 for noop)

def solution(input)
  x_register = 1

  input
    .map { _1.split[1] }
    .reduce([]) { |acc, ins| acc << 0; acc << ins if ins; acc }
    .map
    .with_index(1) do |value, i|
      signal = x_register * i
      x_register += value.to_i
      (i - 20) % 40 == 0 ? signal : 0
    end
    .sum
end

puts solution(File.readlines("input0.txt", chomp: true))
puts solution(File.readlines("input1.txt", chomp: true))