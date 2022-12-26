require '../../aoc_utils'

lines = input_lines

binary_gamma = ""
binary_epsilon = ""

(0...lines[0].length).each do |i|
  # find most common character in column
  counts = Hash.new(0)
  lines.each do |line|
    counts[line[i]] += 1
  end
  most_common = counts.max_by { |k, v| v }[0]
  binary_gamma += most_common == '1' ? '1' : '0'
  binary_epsilon += most_common == '0' ? '1' : '0'
end

puts "Solution 1: #{binary_gamma.to_i(2) * binary_epsilon.to_i(2)}"

# Solution 2
cur_index = 0
lines = input_lines
while lines.size > 1
  counts = Hash.new(0)
  lines.each do |line|
    counts[line[cur_index]] += 1
  end
  most_common = counts['0'] == counts['1']  ? '1' : counts.max_by { |k, v| v }[0]
  lines = lines.select { |line| line[cur_index] == most_common }
  cur_index += 1
end

oxygen = lines[0].to_i(2)
cur_index = 0
lines = input_lines
while lines.size > 1
  counts = Hash.new(0)
  lines.each do |line|
    counts[line[cur_index]] += 1
  end
  most_common = counts['0'] == counts['1'] ? '1' : counts.max_by { |k, v| v }[0]
  lines = lines.select { |line| line[cur_index] != most_common }
  cur_index += 1
end
co2 = lines[0].to_i(2)

puts "Solution 2: #{oxygen * co2}"
