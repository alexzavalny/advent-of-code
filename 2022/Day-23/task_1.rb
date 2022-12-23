require '../../aoc_utils.rb'
require 'set'

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

def elf_to_string_short(elves, i)
  alphabet = ('a'..'z').to_a
  alphabet[i]
  "#"
end

def elf_to_string(elves, i)
  alphabet = ('a'..'z').to_a
  "#{alphabet[i]}: #{elves[i]}"
end

def count_of_empty_cells_in_smallest_area(elves)
  max_x = elves.map { |elf| elf[0] }.max
  max_y = elves.map { |elf| elf[1] }.max
  min_x = elves.map { |elf| elf[0] }.min
  min_y = elves.map { |elf| elf[1] }.min

  empty_cells = 0

  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      elves_index = elves.index([x, y])

      if elves_index.nil?
        empty_cells += 1
      end
    end
  end

  empty_cells
end

def no_elves_close?(elves, elf)
  x, y = elf
  #puts "Checking if elf #{elf_to_string(elves, elves.index(elf))} is alone"
  close = elves.find_index do |other_elf| 
    other_elf != elf && (other_elf[0] - x).abs <= 1 && (other_elf[1] - y).abs <= 1
  end
  if close
    #puts "Elf #{elf_to_string(elves, elves.index(elf))} is close to #{elf_to_string(elves, close)}"
  else
    #puts "Elf #{elf_to_string(elves, elves.index(elf))} is alone"
  end

  return close.nil?
end

def print_elves_map(elves)
  max_x = elves.map { |elf| elf[0] }.max
  max_y = elves.map { |elf| elf[1] }.max
  min_x = elves.map { |elf| elf[0] }.min
  min_y = elves.map { |elf| elf[1] }.min

  puts

  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      elves_index = elves.index([x, y])

      if !elves_index.nil?
        print elf_to_string_short(elves, elves_index)
      else
        print '.'
      end
    end
    puts
  end

  puts
end

def solution(input)
  # read all lines from input and store coodinates of each '#' in a hash
  elves = []
  input.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      if char == '#'
        elves << [x, y]
      end
    end
  end

  direction_check = [:north, :south, :west, :east]

  #  If there is no Elf in the N, NE, or NW adjacent positions, the Elf proposes moving north one step.
  # If there is no Elf in the S, SE, or SW adjacent positions, the Elf proposes moving south one step.
  # If there is no Elf in the W, NW, or SW adjacent positions, the Elf proposes moving west one step.
  # If there is no Elf in the E, NE, or SE adjacent positions, the Elf proposes moving east one step.
  puts "Initial state"
  #print_elves_map(elves)
  #gets

  10.times do |round|
    #puts "Round #{round + 1}"

    proposed_moves = { }
    #puts "Current direction check: #{direction_check}"

    elves.each_with_index do |elf, elf_index|
      x, y = elf

      proposed_moves[elf] = []

      if no_elves_close?(elves, elf)
        #puts "Elf #{elf_to_string(elves, elf_index)} is alone"
        next
      end

      direction_check.each do |direction|
        if direction == :north && no_elves_in?(elves, elf, :north) && no_elves_in?(elves, elf, :north_east) && no_elves_in?(elves, elf, :north_west)
          #puts "Elf #{elf_to_string(elves, elf_index)} proposes to move north"
          proposed_moves[elf] << [x, y - 1] 
          break
        end

        if direction == :south && no_elves_in?(elves, elf, :south) && no_elves_in?(elves, elf, :south_east) && no_elves_in?(elves, elf, :south_west)
          #puts "Elf #{elf_to_string(elves, elf_index)} proposes to move south"
          proposed_moves[elf] << [x, y + 1] 
          break
        end
        
        if direction == :west && no_elves_in?(elves, elf, :west) && no_elves_in?(elves, elf, :north_west) && no_elves_in?(elves, elf, :south_west)
          #puts "Elf #{elf_to_string(elves, elf_index)} proposes to move west"
          proposed_moves[elf] << [x - 1, y] 
          break
        end

        if direction == :east &&  no_elves_in?(elves, elf, :east) && no_elves_in?(elves, elf, :north_east) && no_elves_in?(elves, elf, :south_east)
          #puts "Elf #{elf_to_string(elves, elf_index)} proposes to move east"
          proposed_moves[elf] << [x + 1, y] 
          break
        end
      end
    end

    #p proposed_moves

    # move all elves to their proposed positions if only one elf is proposed to move to a given position
    moves_count = 0
    elves.each_with_index do |elf, i|
      proposed_move = proposed_moves[elf].first
      if !proposed_move.nil? && proposed_moves.values.flatten(1).count(proposed_move) == 1
        moves_count += 1
        #puts "Elf #{elf_to_string(elves, i)} moves to #{proposed_move}"
        elves[i] = proposed_move
      else
        #puts "Elf #{elf_to_string(elves, i)} can't move"
      end
    end

    if moves_count == 0
      puts "No moves were made"
      break
    end

    #p elves
    direction_check.rotate!

    #print_elves_map(elves)
    #gets
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