require '../../aoc_utils.rb'

LOG_MODE = false
GETS = false

DIRECTION_OFFSETS = {
  right: { x: 1, y: 0 },
  left: { x: -1, y: 0 },
  up: { x: 0, y: -1 },
  down: { x: 0, y: 1 }
}

def print_map(map, direction, pos)
  puts map
  puts
  puts "direction: #{direction}, pos: #{pos}"
  puts "[enter] to continue"
end 

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

def direction_to_string(direction)
  case direction
  when :right then '>'
  when :left then '<'
  when :up then '^'
  when :down then 'v'
  end
end

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

#Facing is 0 for right (>), 1 for down (v), 2 for left (<), and 3 for up (^)
def facing(direction)
  case direction
  when :right then 0
  when :down then 1
  when :left then 2
  when :up then 3
  end
end

def go_around!(map, new_pos, direction)
  # we are on the edge, but we can go around
  # if we are facing right, we jump to the first dot on this line
  if direction == :right
    # index of non-space character regexp
    new_pos[:x] = map[new_pos[:y]].index(/[^ ]/)
  end

  # if we are facing left, we jump to the last dot on this line
  if direction == :left
    new_pos[:x] = map[new_pos[:y]].rindex(/[^ ]/)
  end

  # if we are facing up, we jump to the first dot on this column
  if direction == :up
    new_pos[:y] = map.rindex { |line| line[new_pos[:x]] != ' ' }
  end

  # if we are facing down, we jump to the last dot on this column
  if direction == :down
    new_pos[:y] = map.index { |line| line[new_pos[:x]] != ' ' }
  end
end

def make_a_move(pos, direction)
  {x: pos[:x] + DIRECTION_OFFSETS[direction][:x],
    y: pos[:y] + DIRECTION_OFFSETS[direction][:y] }
end

def walk(map, path)
  # find start position -- first occurence of dot in first line
  pos = { x: map[1].index('.'), y: 1 }
  direction = :right

  wp(:path) {} if LOG_MODE
  path.in_groups_of(2).each do |steps, turn|
    wp(:steps) {} if LOG_MODE
    wp(:turn) {} if LOG_MODE
    print_map(map, direction, pos) if LOG_MODE
    gets if LOG_MODE && GETS

    steps.to_i.times do
      puts if LOG_MODE
      # leave a trace
      map[pos[:y]][pos[:x]] = direction_to_string(direction)

      print_map(map, direction, pos) if LOG_MODE

      # move
      new_pos = make_a_move(pos, direction)

      wp(:pos) {} if LOG_MODE
      wp("map[pos[:y]][pos[:x]]".to_sym) {} if LOG_MODE
      wp(:new_pos) {} if LOG_MODE
      wp("map[new_pos[:y]][new_pos[:x]]".to_sym) {} if LOG_MODE

      # check if we are out of bounds
      if map[new_pos[:y]][new_pos[:x]] == ' '
        puts "out of bounds" if LOG_MODE
        
        go_around!(map, new_pos, direction)
      end

      # check if we hit a wall
      if map[new_pos[:y]][new_pos[:x]] == '#'
        puts "hit a wall" if LOG_MODE
        break # we hit a wall, so we can't move any further
      end

      pos = new_pos

      print_map(map, direction, pos) if LOG_MODE
      gets if LOG_MODE && GETS
    end

    direction = turn_direction(direction, turn)
  end
  
  puts "password: #{password(pos, direction)}"
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

walk(map, path)