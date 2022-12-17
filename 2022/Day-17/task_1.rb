def print_chamber_with_rock
  print "nihera"
end

def stuck?
  print "checking if stuck"
end

def perss

def solution(input)
  @width = 7
  @height = 0
  @chamber = [[1] * 7]
  @xpos = 0
  @ypos = 0

  @rocks = [ 
    [[1, 1, 1, 1]],
    [[0, 1, 0], [1, 1, 1], [0, 1, 0]],
    [[0, 0, 1], [0, 0, 1], [1, 1, 1]],
    [[1], [1], [1], [1]],
    [[1, 1],[1, 1]]
  ]

  @rock_index = 0
  @current_rock = nil

  5.times do
    #start rock
    @current_rock = @rocks[@rock_index]
    @xpos = 2
    @ypos = @height + 3

    #blow wind
    (input.chars).each do |c|
      #make movement if you can
      print_chamber_with_rock

      #move down
      @ypos -= 1

      #print chamber
      print_chamber_with_rock

      #if it is stuck, break
      break if stuck?
    end

    #persist the rock into the chamber
    persist_rock

    #recalculate max height
    @height = [@height, @ypos].max
  end

  @height
end

puts solution(File.readlines("input0.txt").first)