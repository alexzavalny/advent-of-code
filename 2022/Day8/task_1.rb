require 'set'
forest = File.readlines(ARGV[0]).map { |x| x.chars.map { |y| y.to_i } }
visible = Set[]
MAX = forest.count

convert_direction = -> (x, y, dir) { return [[x, y], [x, MAX-y-1], [y, x], [MAX-y-1, x]][dir] }

(0..3).each do |direction|
  (0...MAX).each do |i|
    max_heights = [-1] * 4

    (0...MAX).each do |j|
      x, y = convert_direction.(i, j, direction)

      if forest[x][y] > max_heights[direction]
        max_heights[direction] = forest[x][y]
        visible.add([x,y])
      end
    end
  end
end

p visible.size
