require '../../aoc_utils.rb'

LOG_MODE = false
GETS = false

#The final password is the sum of 1000 times the row, 4 times the column, and the facing.
def password(position, direction)
  puts if LOG_MODE
  puts "calculating password" if LOG_MODE
  facing_num = facing(direction)
  # log all parameters
  wp(:position) {} if LOG_MODE
  wp(:direction) {} if LOG_MODE
  wp(:facing_num) {} if LOG_MODE
  position[:y] * 1000 + position[:x] * 4 + facing(direction)
end

DIRECTION_OFFSETS = {
  right: { x: 1, y: 0 },
  left: { x: -1, y: 0 },
  up: { x: 0, y: -1 },
  down: { x: 0, y: 1 }
}

def turn_direction(current_direction, turn)
  case turn
  when 'L'
    case current_direction
    when :right then :up
    when :left then :down
    when :up then :left
    when :down then :right
    end
  when 'R'
    case current_direction
    when :right then :down
    when :left then :up
    when :up then :right
    when :down then :left
    end
  else
    current_direction
  end
end

def facing(direction)
  case direction
  when :right then 0
  when :down then 1
  when :left then 2
  when :up then 3
  end
end

def magic_jump(pos, direction)
  new_pos = {}

  if (direction == :right) #right
    if (pos[:y] <= 50) 
      new_direction = :left
      new_pos[:y] = 151 - pos[:y]
      new_pos[:x] = 100
    elsif (pos[:y] <= 100)
      new_direction = :up
      new_pos[:y] = 50
      new_pos[:x] = 50 + pos[:y]
    elsif (pos[:y] <= 150)
      new_direction = :left
      new_pos[:y] = 151 - pos[:y]
      new_pos[:x] = 150
    else
      new_direction = :up
      new_pos[:y] = 150
      new_pos[:x] = pos[:y] - 100
    end
  end

  if (direction == :down) 
    if (pos[:x] <= 50) 
      new_direction = :down
      new_pos[:y] = 1
      new_pos[:x] = pos[:x] + 100
    elsif (pos[:x] <= 100) 
      new_direction = :left
      new_pos[:y] = pos[:x] + 100
      new_pos[:x] = 50
    else 
      new_direction = :left
      new_pos[:y] = pos[:x] - 50
      new_pos[:x] = 100
    end
  end

  if (direction == :left)
    if (pos[:y] <= 50)
      new_direction = :right
      new_pos[:y] = 151 - pos[:y]
      new_pos[:x] = 1
    elsif (pos[:y] <= 100)
      new_direction = :down
      new_pos[:y] = 101
      new_pos[:x] = pos[:y] - 50
    elsif (pos[:y] <= 150)
      new_direction = :right
      new_pos[:y] = 151 - pos[:y]
      new_pos[:x] = 51
    else
      new_direction = :down
      new_pos[:y] = 1
      new_pos[:x] = pos[:y] - 100
    end
  end

  if (direction == :up) 
    if (pos[:x] <= 50) 
      new_direction = :right
      new_pos[:y] = pos[:x] + 50
      new_pos[:x] = 51
    elsif (pos[:x] <= 100) 
      new_direction = :right
      new_pos[:y] = pos[:x] + 100
      new_pos[:x] = 1
    else 
      new_direction = :up
      new_pos[:y] = 200
      new_pos[:x] = pos[:x] - 100
    end
  end

  [new_pos, new_direction]
end

def make_a_move(pos, direction)
  {x: pos[:x] + DIRECTION_OFFSETS[direction][:x],
    y: pos[:y] + DIRECTION_OFFSETS[direction][:y] }
end

def walk(map, path)
  pos = { x: map[1].index('.'), y: 1 }
  direction = :right

  path.in_groups_of(2).each do |steps, turn|
    steps.to_i.times do
      new_pos = make_a_move(pos, direction)
      new_direction = direction

      if (map[new_pos[:y]][new_pos[:x]] == " ")
        new_pos, new_direction = magic_jump(new_pos, direction)
      end

      if map[new_pos[:y]][new_pos[:x]] == "."
        pos = new_pos
        direction = new_direction
      end
    end

    direction = turn_direction(direction, turn)
  end

  puts [pos[:y], pos[:x], direction]
  return password(pos, direction)
end

# read lines from file
def prepare_map_and_path(file)
  content = File.read(file).split("\n\n")
  map = content.first.split("\n")
  map = [" "] + map.map { |line| " " + line + " " } + [" "]
  max_line_length = map.map(&:length).max
  map = map.map { |line| line + " " * (max_line_length - line.length) }
  path_string = content.last
  path = (path_string.scan(/(\d+)|(\w)/).map(&:compact) + ["-"]).flatten
  [map, path]
end

map, path = prepare_map_and_path("input1.txt")
puts walk(map, path)