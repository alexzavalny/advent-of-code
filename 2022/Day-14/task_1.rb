require 'set'

def solution(input)
  rocks = Set[]
  lowest_point = 0

  input.each do |line|
    blocks = line.split(" -> ")
    
    (blocks.size - 1).times do |ndx|
      block1 = blocks[ndx].split(",").map(&:to_i)
      block2 = blocks[ndx + 1].split(",").map(&:to_i)

      lowest_point = [block1[1], block2[1], lowest_point].max

      if block1[0] == block2[0]
        ([block1[1], block2[1]].min..[block1[1], block2[1]].max).each do |y|
          rocks << [block1[0], y]
        end
      end

      if block1[1] == block2[1]
        ([block1[0], block2[0]].min..[block1[0], block2[0]].max).each do |x|
          rocks << [x, block1[1]]
        end
      end
    end
  end

  off_the_cliff = false
  sands = 0

  while !off_the_cliff do
    sand = [500, 0]
    sands += 1
    moving = true

    while moving
      if sand[1] > lowest_point
        off_the_cliff = true
        break
      end

      if !rocks.include?([sand[0], sand[1] + 1])
        sand[1] += 1
        next
      end

      if !rocks.include?([sand[0] - 1, sand[1] + 1])
        sand[1] += 1
        sand[0] -= 1
        next
      end

      if !rocks.include?([sand[0] + 1, sand[1] + 1])
        sand[1] += 1
        sand[0] += 1
        next
      end
      
      moving = false
    end

    rocks << sand
  end

  sands - 1
end

puts solution(File.readlines('input1.txt', chomp: true))