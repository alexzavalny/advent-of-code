require 'set'
require 'tty-cursor'
@cursor = TTY::Cursor

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
end

def print_board(left, right, top, bottom, rocks, sands, current, path)
  print @cursor.move_to(0,0)

  (top..bottom).each do |y|
    (left..right).each do |x|
      if y == bottom 
        print "■".gray
        next
      end

      if rocks.include?([x, y])
        print "■".blue
        next
      end

      if sands.include?([x, y]) 
        print "+".brown
        next
      end

      if current == [x, y]
        print "*".brown
        next
      end

      if path.include?([x, y]) 
        print "|".brown
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
    path = Set[]

    while moving
      # if sands > 0 && sand == [500, 0] && sands % 20 == 0
      #   print_board(200, 800, 0, 180, rocks, sandy, sand, path)
      #   sleep 0.0
      # end
      path << [sand[0], sand[1]]
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

    if sands % 20 == 0
      print_board(200, 800, 0, 169, rocks, sandy, sand, path)
    end

    sandy << sand
  end

  print_board(200, 800, 0, 169, rocks, sandy, sand, [])
  sands
end

print @cursor.hide
puts solution(File.readlines('input1.txt', chomp: true))