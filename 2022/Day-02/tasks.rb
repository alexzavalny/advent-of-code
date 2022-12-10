r1 = ['', 'B X', 'C Y', 'A Z', 'A X', 'B Y', 'C Z', 'C X', 'A Y', 'B Z']
r2 = ['', 'B X', 'C X', 'A X', 'A Y', 'B Y', 'C Y', 'C Z', 'A Z', 'B Z']

p File.readlines('input1.txt', chomp: true).map { |l| r1.index(l) }.sum
p File.readlines('input1.txt', chomp: true).map { |l| r2.index(l) }.sum