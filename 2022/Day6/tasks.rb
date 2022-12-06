str = File.readlines(ARGV[0]).first.chars
MARKER = 4
MSG = 14

puts ((0..str.size).find { str[_1.._1+MARKER-1].uniq.size==MARKER }) + MARKER
puts ((0..str.size).find { str[_1.._1+MSG-1].uniq.size==MSG }) + MSG
