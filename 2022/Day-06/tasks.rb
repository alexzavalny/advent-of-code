str = File.read(ARGV[0]).chars

p str.each_cons(4).map { _1.uniq.size }.index(4) + 4
p str.each_cons(14).map { _1.uniq.size }.index(14) + 14
