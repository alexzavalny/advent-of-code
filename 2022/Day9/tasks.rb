require 'set'
input = File.readlines(ARGV[0], chomp: true)
LENGTH = ARGV[1].to_i

visited = Set[]
move = { "R" => [1, 0], "L" => [-1, 0], "U" => [0, 1], "D" => [0, -1] }
rope = [[0, 0]] * LENGTH

input.each do |line|
  dir = line.split(" ")[0]
  step = line.split(" ")[1].to_i

  step.times do 
    rope[0] = [rope[0][0] + move[dir][0], rope[0][1] + move[dir][1]]

    (LENGTH-1).times do |i|
      rope[i+1] = [rope[i+1][0], rope[i+1][1]]

      if rope[i+1][0] == rope[i][0] && (rope[i+1][1] - rope[i][1]).abs == 2
        rope[i+1][1] -= (rope[i+1][1] - rope[i][1])/2
      end

      if rope[i+1][1] == rope[i][1] && (rope[i+1][0] - rope[i][0]).abs == 2
        rope[i+1][0] -= (rope[i+1][0] - rope[i][0])/2
      end

      if (rope[i+1][0] - rope[i][0]).abs == 2 && (rope[i+1][1] - rope[i][1]).abs == 1
        rope[i+1][1] -= (rope[i+1][1] - rope[i][1])
        rope[i+1][0] -= (rope[i+1][0] - rope[i][0]) / 2
      end

      if (rope[i+1][1] - rope[i][1]).abs == 2 && (rope[i+1][0] - rope[i][0]).abs == 1
        rope[i+1][0] -= (rope[i+1][0] - rope[i][0])
        rope[i+1][1] -= (rope[i+1][1] - rope[i][1]) / 2
      end

      if (rope[i+1][1] - rope[i][1]).abs == 2 && (rope[i+1][0] - rope[i][0]).abs == 2
        rope[i+1][0] -= (rope[i+1][0] - rope[i][0]) / 2
        rope[i+1][1] -= (rope[i+1][1] - rope[i][1]) / 2
      end
    end

    visited.add(rope.last)
  end
end

puts visited.size