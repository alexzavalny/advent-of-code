input = File.readlines(ARGV[0]).map(&:split)
LENGTH = ARGV[1].to_i
rope = [[0, 0]] * LENGTH

visited = []
move = { "R" => [1, 0], "L" => [-1, 0], "U" => [0, 1], "D" => [0, -1] }

input.each do |instruction|
  dir, step = instruction

  step.to_i.times do 
    # move head
    rope[0] = [rope[0][0] + move[dir][0], rope[0][1] + move[dir][1]]

    # move each of tail
    (LENGTH-1).times do |i|
      need_to_move = (rope[i+1][0] - rope[i][0]).abs == 2 || (rope[i+1][1] - rope[i][1]).abs == 2
      rope[i+1] = [rope[i+1][0] - ((rope[i+1][0] - rope[i][0] ) <=> 0),
                  rope[i+1][1] - ((rope[i+1][1] - rope[i][1]) <=> 0)] if need_to_move
    end

    visited << rope.last unless visited.include?(rope.last)
  end
end

puts visited.size