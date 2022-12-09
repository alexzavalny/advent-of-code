def solution(instuctions, length)
  move = { "R" => [1, 0], "L" => [-1, 0], "U" => [0, 1], "D" => [0, -1] }
  rope = [[0, 0]] * length
  visited = []

  instuctions.each do |dir, step|
    step.to_i.times do 
      rope[0] = [rope[0][0] + move[dir][0], rope[0][1] + move[dir][1]]

      (length-1).times do |i|
        cur, nex = rope[i], rope[i+1]
        need_to_move = (nex[0] - cur[0]).abs == 2 || (nex[1] - cur[1]).abs == 2
        
        if need_to_move
          rope[i+1] = [nex[0] - (nex[0] <=> cur[0]), nex[1] - (nex[1] <=> cur[1])]
        end
      end

      visited << rope.last unless visited.include?(rope.last)
    end
  end

  visited.size
end

puts solution(File.readlines(ARGV[0]).map(&:split), ARGV[1].to_i)
