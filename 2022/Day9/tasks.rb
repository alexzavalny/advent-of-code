require "set"
require "matrix"

def solution(instuctions, length)
  move = { "R" => Vector[1, 0], "L" => Vector[-1, 0], "U" =>Vector[0, 1], "D" => Vector[0, -1] }
  rope = [Vector[0, 0]] * length
  visited = Set[]

  instuctions.map(&:split).each do |dir, step|
    step.to_i.times do 
      rope[0] += move[dir]

      (length-1).times do |i|
        cur, nex = rope[i], rope[i+1]
        need_to_move = (nex - cur).map(&:abs).max == 2

        if need_to_move
          rope[i+1] += Vector[cur[0] <=> nex[0], cur[1] <=> nex[1]]
        end
      end

      visited << rope.last
    end
  end

  visited.size
end

puts solution(File.readlines("input0_1.txt"), 2)
puts solution(File.readlines("input0_2.txt"), 10)
puts solution(File.readlines("input1.txt"), 2)
puts solution(File.readlines("input1.txt"), 10)