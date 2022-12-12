require 'set'

def solution(input)
  end_pos = Set[]
  starting_pos = []
  
  hmap = input.map.with_index do | line, y |
    line.chars.map.with_index do |char, x|
      if char == "S" || char == "a"
        end_pos << [x, y]
        1
      elsif char == "E"
        starting_pos = [x, y]
        26
      else
        char.ord - 'a'.ord + 1
      end
    end
  end

  width, height = hmap[0].size, hmap.size
  queue = [ { step: 0, position: starting_pos } ]

  visited = Set[]
  
  while queue.size > 0
    elem = queue.slice!(0)
    next if visited.include?(elem[:position])
    return elem[:step] if end_pos.include?(elem[:position])

    visited << elem[:position]
    x, y = elem[:position]
    step = elem[:step]

    queue << { step: step + 1, position: [x, y-1] } if y - 1 >= 0 && hmap[y][x] - hmap[y - 1][x]  <= 1 unless visited.include?([x, y-1])
    queue << { step: step + 1, position: [x, y+1] } if y + 1 < height && hmap[y][x] - hmap[y + 1][x] <= 1 unless visited.include?([x, y+1])
    queue << { step: step + 1, position: [x-1, y] } if x - 1 >= 0 && hmap[y][x] - hmap[y][x - 1] <= 1 unless visited.include?([x-1, y])
    queue << { step: step + 1, position: [x+1, y] } if x + 1 < width && hmap[y][x] - hmap[y][x + 1]  <= 1 unless visited.include?([x+1, y])
  end
end

puts solution(File.readlines("input1.txt", chomp: true))
