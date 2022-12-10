forest = File.readlines(ARGV[0]).map { |x| x.chars.map { |y| y.to_i } }
MAX = forest.count

shift = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]
max_score = 0

(0...MAX).each do |i|
  (0...MAX).each_with_object(1) do |j, score|
    (0..3).each_with_object(0) do |m, count|
      x, y = i + shift[m][0], j + shift[m][1]

      while x >= 0 && y >= 0 && x < MAX && y < MAX
        count += 1
        break if forest[i][j] <= forest[x][y]
        x, y = x + shift[m][0], y + shift[m][1]
      end

      score *= count
    end

    max_score = score if score > max_score
  end
end

p max_score