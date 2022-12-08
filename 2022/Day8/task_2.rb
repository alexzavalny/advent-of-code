require 'set'
lines = File.readlines(ARGV[0])
visible = Set[]
MAX = lines.count
forest = lines.map { |x| x.chars.map { |y| y.to_i } }
tr = -> (x, y) { forest[x][y] }
tran1 = -> (x, y) { return x, y }
tran2 = -> (x, y) { return x, MAX-y-1 }
tran3 = -> (x, y) { return y, x}
tran4 = -> (x, y) { return MAX-y-1, x }
trans = [tran1, tran2, tran3, tran4]

puts lines

(0..3).each do |w|
  (0...MAX).each do |i|
    m = [-1, -1, -1, -1]

    (0...MAX).each do |j|
      x, y = trans[w].(i, j)
      t = tr.(x, y)
      taking = false
      if t > m[w]
        taking = true
        m[w] = t
        visible.add "#{x}_#{y}"
      end
      puts "Checking (#{x} x #{y}) - #{t} #{ 'yes' if taking}"
    end
  end
end

p visible
p visible.size