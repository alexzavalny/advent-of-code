def solution(input)
  start_pos = []
  end_pos = []

  hmap = input.map.with_index do | line, y |
    line.chars.map.with_index do |char, x|
      if char == "S"
        start_pos = [x, y]
        1
      elsif char == "E"
        end_pos = [x, y]
        26
      else
        char.ord - 96
      end
    end
  end

  step_map = Array.new (hmap.size) { Array.new (hmap[0].size) { -1 } }
  step_map[start_pos[1]][start_pos[0]] = 0

  change_made = true
  while change_made 
    change_made = false
    (0...hmap[0].size).each do |x|
      (0...hmap.size).each do |y|
        available = []
        available << step_map[y-1][x] if y - 1 >= 0 && hmap[y][x] - hmap[y - 1][x] <= 1 && step_map[y-1][x] > -1
        available << step_map[y+1][x] if y + 1 < hmap.size && hmap[y][x] - hmap[y + 1][x] <= 1 && step_map[y+1][x] > -1
        available << step_map[y][x-1] if x - 1 >= 0 && hmap[y][x] - hmap[y][x - 1] <= 1 && step_map[y][x-1] > -1
        available << step_map[y][x+1] if x + 1 < hmap[0].size && hmap[y][x] - hmap[y][x + 1] <= 1 && step_map[y][x+1] > -1

        new_min = available.min + 1 if available.size > 0
        if !new_min.nil? && (new_min < step_map[y][x] || step_map[y][x] == -1)
          step_map[y][x] = new_min
          change_made = true
        end
      end
    end

  end

  step_map[end_pos[1]][end_pos[0]]
end

#puts solution(File.readlines("input0.txt", chomp: true)) == 31
puts solution(File.readlines("input1.txt", chomp: true))