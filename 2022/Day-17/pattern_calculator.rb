data = File.read("pattern1.txt").split(",").map(&:to_i)

pattern_start = 570 / 2
pattern_width = 3430 / 2
start_sum = data[0...pattern_start].sum
pattern = data[pattern_start, pattern_width]
pattern_sum = pattern.sum 

puts "-"
puts pattern_start
puts pattern_width
puts pattern_start + pattern_width
p data[pattern_start, pattern_width]
p data[pattern_start, pattern_width].sum
p data[pattern_start + pattern_width, pattern_width].sum
puts "-"
#start_sum = pattern[0...pattern_start].sum
#p start_sum

repeat = 1_000_000_000_000
rest = repeat % pattern_sum
rest_sum = pattern[pattern_start+rest..rest].sum
repeat_count = repeat / pattern_width
result = start_sum + rest_sum + repeat_count * pattern_sum
puts result

#my result - 1514285714288
#should be - 1514285714288

# too high 1514285714700
# too high 1500874635994
# result   1500874635587