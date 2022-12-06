str = File.read(ARGV[0]).chars

search = -> (s, len) { (len..s.size).find { |i| s[i-len..i-1].uniq.size==len } }

puts search.(str, 4)
puts search.(str, 14)
