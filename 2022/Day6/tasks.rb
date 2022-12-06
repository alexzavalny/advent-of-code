str = File.readlines(ARGV[0]).first.chars
MARKER = 4
MSG = 14

puts (MARKER..str.size).find { |i| str[i-MARKER..i-1].uniq.size==MARKER }
puts (MSG..str.size).find { |i| str[i-MSG..i-1].uniq.size==MSG }
