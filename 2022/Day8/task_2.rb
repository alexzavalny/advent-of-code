forest = File.readlines(ARGV[0]).map { |x| x.chars.map { |y| y.to_i } }
MAX = forest.count

tran1 = -> (x, y) { return x + 1, y }
tran2 = -> (x, y) { return x - 1, y}
tran3 = -> (x, y) { return x, y + 1}
tran4 = -> (x, y) { return x, y - 1}
trans = [tran1, tran2, tran3, tran4]

max_score = 0

(0...MAX).each do |i|
  (0...MAX).each_with_object(1) do |j, score|
    (0..3).each_with_object(0) do |m, count|
      x, y = trans[m].(i, j)

      while x >= 0 && y >= 0 && x < MAX && y < MAX
        count += 1
        break if forest[i][j] <= forest[x][y]
        x, y = trans[m].(x, y)
      end

      score *= count
    end

    max_score = score if score > max_score
  end
end

p max_score