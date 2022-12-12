require 'set'

def adjuscents(x, y, width, height)
  result = []
  result << [x + 1, y] if x + 1 < width
  result << [x - 1, y] if x > 0
  result << [x, y + 1] if y + 1 < height
  result << [x, y - 1] if y > 0
  result
end

def solution(input)
  start_pos, end_pos = [], []

  hmap = input.map.with_index do | line, y |
    line.chars.map.with_index do |char, x|
      if char == "S"
        start_pos = [x, y]
        1
      elsif char == "E"
        end_pos = [x, y]
        26
      else
        char.ord - 'a'.ord + 1
      end
    end
  end

  width, height = hmap[0].size, hmap.size
  queue = [ { step: 0, position: start_pos } ]
  visited = Set[]

  while queue.size > 0
    elem = queue.slice!(0)
    next if visited.include?(elem[:position])
    return elem[:step] if elem[:position] == end_pos

    visited << elem[:position]
    x, y = elem[:position]
    step = elem[:step]

    adjuscents(x, y, width, height).each do |new_x, new_y|
      queue << { step: step + 1, position: [new_x, new_y] } if hmap[new_y][new_x] - hmap[y][x] <= 1 unless visited.include?([new_x, new_y])
    end
  end
end

puts solution(File.readlines("input0.txt", chomp: true))
