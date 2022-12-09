require 'set'
input = File.readlines(ARGV[0], chomp: true)
LENGTH = ARGV[1].to_i
rope = [[0, 0]] * LENGTH

visited = Set[]
move = { "R" => [1, 0], "L" => [-1, 0], "U" => [0, 1], "D" => [0, -1] }
abs_max = -> (x) { x < 0 ? [x, -1].max : [x, 1].min }

input.each do |line|
  dir, step = line.split

  step.to_i.times do 
    rope[0] = [rope[0][0] + move[dir][0], rope[0][1] + move[dir][1]]

    (LENGTH-1).times do |i|
      rope[i+1] = rope[i+1].clone

      if (rope[i+1][0] - rope[i][0]).abs >= 2 || (rope[i+1][1] - rope[i][1]).abs >= 2
        rope[i+1][0] -= abs_max.(rope[i+1][0] - rope[i][0])
        rope[i+1][1] -= abs_max.(rope[i+1][1] - rope[i][1])
      end
    end

    visited.add(rope.last)
  end
end

puts visited.size