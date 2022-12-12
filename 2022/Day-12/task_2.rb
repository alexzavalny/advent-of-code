def solution(input)
  end_pos = []

  starting_points = []
  hmap = input.map.with_index do | line, y |
    line.chars.map.with_index do |char, x|
      if char == "S" || char == "a"
        starting_points << [x, y]
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
  step_map = Array.new (height) { Array.new (width) { -1 } }
  starting_points.each { |sp| step_map[sp[1]][sp[0]] = 0 }

  change_made = true
  while change_made 
    change_made = false
    (0...width).each do |x|
      (0...height).each do |y|
        available = []
        available << step_map[y-1][x] if y - 1 >= 0 && hmap[y][x] - hmap[y - 1][x] <= 1 && step_map[y-1][x] > -1
        available << step_map[y+1][x] if y + 1 < height && hmap[y][x] - hmap[y + 1][x] <= 1 && step_map[y+1][x] > -1
        available << step_map[y][x-1] if x - 1 >= 0 && hmap[y][x] - hmap[y][x - 1] <= 1 && step_map[y][x-1] > -1
        available << step_map[y][x+1] if x + 1 < width && hmap[y][x] - hmap[y][x + 1] <= 1 && step_map[y][x+1] > -1

        min_steps = available.min + 1 if available.size > 0
        if !min_steps.nil? && (min_steps < step_map[y][x] || step_map[y][x] == -1)
          step_map[y][x] = min_steps
          change_made = true
        end
      end
    end

  end

  step_map[end_pos[1]][end_pos[0]]
end

puts solution(File.readlines("input1.txt", chomp: true))
