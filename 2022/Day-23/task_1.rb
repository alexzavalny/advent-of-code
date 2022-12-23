require '../../aoc_utils.rb'
require 'set'

ROUND_COUNT = 10

# Checks if there is an elf in the given direction
def no_elves_in?(elves, elf, compass_direction)
  x, y = elf
  case compass_direction
  when :north
    elves.none? { |other_elf| other_elf == [x, y - 1] }
  when :south
    elves.none? { |other_elf| other_elf == [x, y + 1] }
  when :west
    elves.none? { |other_elf| other_elf == [x - 1, y] }
  when :east
    elves.none? { |other_elf| other_elf == [x + 1, y] }
  when :north_west
    elves.none? { |other_elf| other_elf == [x - 1, y - 1] }
  when :north_east
    elves.none? { |other_elf| other_elf == [x + 1, y - 1] }
  when :south_west
    elves.none? { |other_elf| other_elf == [x - 1, y + 1] }
  when :south_east
    elves.none? { |other_elf| other_elf == [x + 1, y + 1] }
  end
end

def count_of_empty_cells_in_smallest_area(elves)
  max_x = elves.map { |elf| elf[0] }.max
  max_y = elves.map { |elf| elf[1] }.max
  min_x = elves.map { |elf| elf[0] }.min
  min_y = elves.map { |elf| elf[1] }.min

  total_cells = (max_x - min_x + 1) * (max_y - min_y + 1)
  total_cells - elves.size
end

def no_elves_close?(elves, elf)
  x, y = elf
  elves.find_index { |el| el != elf && (el[0] - x).abs <= 1 && (el[1] - y).abs <= 1 }.nil?
end

def solution(input)
  elves = []
  input.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      if char == '#'
        elves << [x, y]
      end
    end
  end

  direction_check = [:north, :south, :west, :east]

  ROUND_COUNT.times do |round|
    puts "Round #{round + 1}"

    proposed_moves = { }

    elves.each_with_index do |elf, elf_index|
      x, y = elf

      proposed_moves[elf] = []

      next if no_elves_close?(elves, elf)

      direction_check.each do |direction|
        if direction == :north && no_elves_in?(elves, elf, :north) && no_elves_in?(elves, elf, :north_east) && no_elves_in?(elves, elf, :north_west)
          proposed_moves[elf] << [x, y - 1] 
          break
        end

        if direction == :south && no_elves_in?(elves, elf, :south) && no_elves_in?(elves, elf, :south_east) && no_elves_in?(elves, elf, :south_west)
          proposed_moves[elf] << [x, y + 1] 
          break
        end
        
        if direction == :west && no_elves_in?(elves, elf, :west) && no_elves_in?(elves, elf, :north_west) && no_elves_in?(elves, elf, :south_west)
          proposed_moves[elf] << [x - 1, y] 
          break
        end

        if direction == :east &&  no_elves_in?(elves, elf, :east) && no_elves_in?(elves, elf, :north_east) && no_elves_in?(elves, elf, :south_east)
          proposed_moves[elf] << [x + 1, y] 
          break
        end
      end
    end

    moves_count = 0
    elves.each_with_index do |elf, i|
      proposed_move = proposed_moves[elf].first
      if !proposed_move.nil? && proposed_moves.values.flatten(1).count(proposed_move) == 1
        moves_count += 1
        elves[i] = proposed_move
      end
    end

    direction_check.rotate!
  end

  puts count_of_empty_cells_in_smallest_area(elves)
end

def prepare_map(filename)
  content = File.read(filename).split("\n\n")
  map = content.first.split("\n")
  map = [" "] + map.map { |line| " " + line + " " } + [" "]
  max_line_length = map.map(&:length).max
  map =  map.map { |line| line + " " * (max_line_length - line.length) }
end

solution(prepare_map('input0-big.txt'))