require '../../aoc_utils.rb'
require 'set'

# Checks if there is an elf in the given direction
def no_elves_in?(elves, elf, compass_direction)
  x, y = elf

  case compass_direction
  when :north
    !elves.include?([x, y - 1])
  when :south
    !elves.include?([x, y + 1])
  when :west
    !elves.include?([x - 1, y])
  when :east
    !elves.include?([x + 1, y])
  when :north_west
    !elves.include?([x - 1, y - 1])
  when :north_east
    !elves.include?([x + 1, y - 1])
  when :south_west
    !elves.include?([x - 1, y + 1])
  when :south_east
    !elves.include?([x + 1, y + 1])
  end
end

def no_elves_close?(elves, elf)
  x, y = elf
  positions_to_check = [ 
    [x - 1, y - 1], 
    [x, y - 1], 
    [x + 1, y - 1], 
    [x - 1, y], 
    [x + 1, y], 
    [x - 1, y + 1], 
    [x, y + 1], 
    [x + 1, y + 1] 
  ]
  some_elf_is_near = false
  positions_to_check.each do |position|
    if elves.include?(position)
      some_elf_is_near = true
      break
    end
  end

  !some_elf_is_near
end

def print_elves_map(elves)
  max_x = elves.map { |elf| elf[0] }.max
  max_y = elves.map { |elf| elf[1] }.max
  min_x = elves.map { |elf| elf[0] }.min
  min_y = elves.map { |elf| elf[1] }.min

  puts

  (min_y..max_y).each do |y|
    (min_x..max_x).each do |x|
      if elves.include?([x, y])
        print "#"
      else
        print '.'
      end
    end
    puts
  end

  puts
end

def solution(input)
  elves = Set[]
  input.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      if char == '#'
        elves << [x, y]
      end
    end
  end

  direction_check = [:north, :south, :west, :east]
  round = 1

  while true
    puts "Round #{round}"

    proposed_moves = { }
    proposed_moves_bucket = {}

    elves.each_with_index do |elf|
      x, y = elf

      proposed_moves[elf] = []

      next if no_elves_close?(elves, elf)

      direction_check.each do |direction|
        if direction == :north && no_elves_in?(elves, elf, :north) && no_elves_in?(elves, elf, :north_east) && no_elves_in?(elves, elf, :north_west)
          proposed_moves[elf] << [x, y - 1] 
          proposed_moves_bucket[[x, y - 1]] ||= 0
          proposed_moves_bucket[[x, y - 1]] += 1
          break
        end

        if direction == :south && no_elves_in?(elves, elf, :south) && no_elves_in?(elves, elf, :south_east) && no_elves_in?(elves, elf, :south_west)
          proposed_moves[elf] << [x, y + 1] 
          proposed_moves_bucket[[x, y + 1]] ||= 0
          proposed_moves_bucket[[x, y + 1]] += 1
          break
        end
        
        if direction == :west && no_elves_in?(elves, elf, :west) && no_elves_in?(elves, elf, :north_west) && no_elves_in?(elves, elf, :south_west)
          proposed_moves[elf] << [x - 1, y] 
          proposed_moves_bucket[[x - 1, y]] ||= 0
          proposed_moves_bucket[[x - 1, y]] += 1
          break
        end

        if direction == :east &&  no_elves_in?(elves, elf, :east) && no_elves_in?(elves, elf, :north_east) && no_elves_in?(elves, elf, :south_east)
          proposed_moves[elf] << [x + 1, y] 
          proposed_moves_bucket[[x + 1, y]] ||= 0
          proposed_moves_bucket[[x + 1, y]] += 1
          break
        end
      end
    end

    # move all elves to their proposed positions if only one elf is proposed to move to a given position
    moves_count = 0
    elves_copy = elves.dup
    elves.each_with_index do |elf|
      proposed_move = proposed_moves[elf].first
      if !proposed_move.nil? && proposed_moves_bucket[proposed_move] == 1
        moves_count += 1
        elves_copy.delete(elf)
        elves_copy << proposed_move
      end
    end

    elves = elves_copy
    if moves_count == 0
      puts "No moves were made"
      break
    end

    direction_check.rotate!    
    round += 1
  end

  puts round
end

def prepare_map(filename)
  content = File.read(filename).split("\n\n")
  map = content.first.split("\n")
  map = [" "] + map.map { |line| " " + line + " " } + [" "]
  max_line_length = map.map(&:length).max
  map =  map.map { |line| line + " " * (max_line_length - line.length) }
end

#solution(prepare_map('input0-big.txt'))
require 'benchmark'
puts Benchmark.measure { solution(prepare_map('input0-big.txt')) }
