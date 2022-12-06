str = File.readlines(ARGV[0]).first.chars
MARKER = 4
MSG = 14

puts ((0..str.size).find { |i| str[i..i+MARKER-1].uniq.size==MARKER }) + MARKER
puts ((0..str.size).find { |i| str[i..i+MSG-1].uniq.size==MSG }) + MSG
