def solution(instuctions, length)
  move = { "R" => [1, 0], "L" => [-1, 0], "U" => [0, 1], "D" => [0, -1] }
  rope = [[0, 0]] * length

  instuctions.each_with_object([]) do |ins, visited|
    dir, step = ins

    step.to_i.times do 
      # move head
      rope[0] = [rope[0][0] + move[dir][0], rope[0][1] + move[dir][1]]

      # move each of ta
      (length-1).times do |i|
        need_to_move = (rope[i+1][0] - rope[i][0]).abs == 2 || (rope[i+1][1] - rope[i][1]).abs == 2
        rope[i+1] = [rope[i+1][0] - ((rope[i+1][0] - rope[i][0] ) <=> 0),
                    rope[i+1][1] - ((rope[i+1][1] - rope[i][1]) <=> 0)] if need_to_move
      end

      visited << rope.last unless visited.include?(rope.last)
    end
  end.size
end

puts solution(File.readlines(ARGV[0]).map(&:split), ARGV[1].to_i)
