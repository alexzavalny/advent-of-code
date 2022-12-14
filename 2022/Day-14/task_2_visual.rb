require 'set'
require 'tty-cursor'
@cursor = TTY::Cursor

def print_board(left, right, top, bottom, rocks, sands, current)
  print @cursor.move_to(0,0)

  (top..bottom).each do |y|
    (left..right).each do |x|
      if rocks.include?([x, y])
        print "■"
        next
      end

      if sands.include?([x, y]) 
        print "+"
        next
      end

      if current == [x, y]
        print "*"
        next
      end

      print " "
    end
    print("\n")
  end

end

def solution(input)
  rocks = Set[]
  lowest_point = 0

  input.each do |line|
    blocks = line.split(" -> ")
    
    (blocks.size - 1).times do |ndx|
      block1 = blocks[ndx].split(",").map(&:to_i)
      block2 = blocks[ndx + 1].split(",").map(&:to_i)

      lowest_point = [block1[1], block2[1], lowest_point].max

      ([block1[1], block2[1]].min..[block1[1], block2[1]].max).each do |y|
        ([block1[0], block2[0]].min..[block1[0], block2[0]].max).each do |x|
          rocks << [x, y]
        end
      end
    end
  end

  sands = 0
  sandy = Set[]
  while !sandy.include?([500, 0]) do
    sand = [500, 0]
    sands += 1
    moving = true

    while moving
      if sands > 0 && sand == [500, 0] && sands % 20 == 0
        print_board(200, 800, 0, 180, rocks, sandy, sand)
        sleep 0.0
      end

      break if sand[1] > lowest_point

      moving = false

      break if sand[1] + 1 > lowest_point + 2

      [[0, 1], [-1, 1], [1, 1]].each do |offset|
        if !rocks.include?([sand[0] + offset[0], sand[1] + offset[1]]) && !sandy.include?([sand[0] + offset[0], sand[1] + offset[1]])
          sand[1] += offset[1]
          sand[0] += offset[0]
          moving = true
          break
        end       
      end
    end

    sandy << sand
  end

  print_board(200, 800, 0, 180, rocks, sandy, sand)
  sands
end

puts solution(File.readlines('input1.txt', chomp: true))