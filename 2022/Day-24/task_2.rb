require '../../aoc_utils.rb'
require 'set'
def blizzard_to_string(blizzards)
  return blizzards.size.to_s if blizzards.size > 1

  case blizzards.first
  when :north
    '^'
  when :south
    'v'
  when :west
    '<'
  when :east
    '>'
  end
end

def print_map(our_coordinates, blizzards, borders)
  wp(:our_coordinates) {}
  min_x = 0
  min_y = 0
  max_x = borders.map { |border| border[0] }.max
  max_y = borders.map { |border| border[1] }.max

  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      if our_coordinates.any? { |coord| coord[:x] == x && coord[:y] == y }
        print 'E'
      elsif !blizzards[[x, y]].nil?
        print blizzard_to_string(blizzards[[x, y]])
      elsif borders.include?([x, y])
        print '#'
      else
        print '.'
      end
    end
    puts
  end
end

def solution(blizzards, borders)
  width = borders.map { |border| border[0] }.max
  height = borders.map { |border| border[1] }.max
  my_positions_queue = [ { minute: 0, positions: [ x: 1, y: 0, target: 0] } ]
  destinations_y = [ height, 0, height ]
  wp(:my_positions_queue) {}
  found_targets = Set[]
  while my_positions_queue.size > 0
    minutes_positions = my_positions_queue.shift
    break if minutes_positions.nil?
    if minutes_positions[:minute] % 10 == 0
      puts "Current minute: #{minutes_positions[:minute]}" 
      puts "Variations: #{minutes_positions[:positions].size}"
    end
    new_blizzards = { }
    blizzards.each_key do |blizzard_coord|
      #wp(:blizzard_coord) {}
      directions = blizzards.delete(blizzard_coord)
      #wp(:directions) {}
      directions.each do |direction|
        new_coordinates = []
        case direction
        when :north
          new_coordinates = [blizzard_coord[0], blizzard_coord[1] - 1]
          if borders.include?(new_coordinates)
            new_coordinates = [blizzard_coord[0], height - 1]
          end
        when :south
          new_coordinates = [blizzard_coord[0], blizzard_coord[1] + 1]
          if borders.include?(new_coordinates)
            new_coordinates = [blizzard_coord[0], 1]
          end
        when :west
          new_coordinates = [blizzard_coord[0] - 1, blizzard_coord[1]]
          if borders.include?(new_coordinates)
            new_coordinates = [width - 1, blizzard_coord[1]]
          end
        when :east
          new_coordinates = [blizzard_coord[0] + 1, blizzard_coord[1]]
          if borders.include?(new_coordinates)
            new_coordinates = [1, blizzard_coord[1]]
          end
        end

        new_blizzards[new_coordinates] ||= []
        new_blizzards[new_coordinates] << direction
      end
    end

    blizzards = new_blizzards

    position_offsets = [ [-1, 0], [1, 0], [0, -1], [0, 1], [0, 0] ]

    next_minute_positions = { minute: minutes_positions[:minute] + 1, positions: Set[] }
    
    minutes_positions[:positions].each do |my_position|
      position_offsets.each do |offset|
        new_potential_position = { x: my_position[:x] + offset[0], y: my_position[:y] + offset[1], target: my_position[:target] }

        if new_potential_position[:x] <= 0 ||
            new_potential_position[:x] >= width ||
            new_potential_position[:y] < 0 ||
            new_potential_position[:y] > height
          next
        end

        next if borders.include?([new_potential_position[:x], new_potential_position[:y]])
        next unless blizzards[[new_potential_position[:x], new_potential_position[:y]]].nil?

        current_destination = destinations_y[my_position[:target]]
        if new_potential_position[:y] == current_destination
          new_potential_position[:target] += 1
          unless found_targets.include?(new_potential_position[:target])
            puts "Target #{new_potential_position[:target]} at best score #{minutes_positions[:minute] + 1}"
            found_targets << new_potential_position[:target]
          end

          if new_potential_position[:target] == 3
            puts "Found it at #{minutes_positions[:minute] + 1} New Target #{new_potential_position[:target]}!"
            my_positions_queue = []
            next_minute_positions = nil
            break
          end
        end

        next_minute_positions[:positions] << new_potential_position unless next_minute_positions.nil?
      end
    end
    my_positions_queue << next_minute_positions
  end
end

def symbol_to_direction(symbol)
  case symbol
  when '^'
    :north
  when 'v'
    :south
  when '<'
    :west
  when '>'
    :east
  end
end

def prepare_data(file)
  map_of_symbols = File.read(file).split("\n").map { |line| line.split('') }
  borders = Set[ ] # {x, y } # if symbol = "#"
  map_of_symbols.each_with_index do |line, y|
    line.each_with_index do |symbol, x|
      borders << [x, y] if symbol == '#'
    end
  end
  
  #wp(:borders) {}

  blizzards = { } # { [x, y] => direction }
  map_of_symbols.each_with_index do |line, y|
    line.each_with_index do |symbol, x|
      direction = symbol_to_direction(symbol)
      blizzards[[x, y]] = [direction] if !direction.nil?
    end
  end

  #wp(:blizzards) {}

  [blizzards, borders]
end


require 'benchmark'
puts Benchmark.measure {
  blizzards, borders = prepare_data('input1.txt')
  solution(blizzards, borders)
}