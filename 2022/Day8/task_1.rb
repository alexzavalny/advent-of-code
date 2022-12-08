require 'set'
forest = File.readlines(ARGV[0]).map { |x| x.chars.map { |y| y.to_i } }
visible = Set[]
MAX = forest.count

tran1 = -> (x, y) { return x, y }
tran2 = -> (x, y) { return x, MAX-y-1 }
tran3 = -> (x, y) { return y, x}
tran4 = -> (x, y) { return MAX-y-1, x }
trans = [tran1, tran2, tran3, tran4]

(0..3).each do |direction|
  (0...MAX).each do |i|
    mx = [-1, -1, -1, -1]

    (0...MAX).each do |j|
      x, y = trans[direction].(i, j)

      if forest[x][y] > mx[direction]
        mx[direction] = forest[x][y]
        visible.add "#{x}_#{y}"
      end
    end
  end
end

p visible.size
