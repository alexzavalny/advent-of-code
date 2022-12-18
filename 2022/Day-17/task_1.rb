def print_chamber_with_rock
  puts "[#{@step}] Chamber height #{@chamber.size}. Rock coords: #{@xpos}, #{@ypos}:"
  puts
  (@ypos).times do |my|
    y = @ypos - my
    print '|'
    (7).times do |x|
      rockx = x - @xpos
      rocky = y - @ypos + rock_height - 1

      if !@current_rock.nil? && rockx >= 0 && rocky >= 0 && rocky < @current_rock.size && 
        rockx < @current_rock[rocky].size && @current_rock[rocky][rockx] == 1
        print '@'
      elsif y < @chamber.size && x < @width && @chamber[y][x] == 1
        print "#"
      else
        print '.'
      end
    end
    print '|'
    print("\n")
  end

  print "+-------+\n"
  puts
  #gets
end

def would_overlap?(new_x, new_y)
  @current_rock.size.times do |rock_y|
    inv_y = @current_rock.size - rock_y - 1
    @current_rock[0].size.times do |rock_x|
      if @current_rock[inv_y][rock_x] == 1
        if !@chamber[new_y - rock_y].nil? && @chamber[new_y - rock_y][rock_x + new_x] == 1
          return true
        end
      end
    end
  end

  return false
end

def can_move_down?
  #puts "checking if stuck #{@ypos} #{rock_height}"
  return false if @ypos - rock_height == 0
  return !would_overlap?(@xpos, @ypos - 1)
end

def can_move_left?
  return false if @xpos == 0
  return !would_overlap?(@xpos - 1, @ypos)
end

def can_move_right?
  puts "can_move_right"
  p "Current rock: #{@current_rock}"
  return false if @xpos + @current_rock.first.size == @width
  return !would_overlap?(@xpos + 1, @ypos)
end

def rock_height
  !@current_rock.nil? ? @current_rock.size : 0
end

def persist_rock
  @chamber << [ 0, 0, 0, 0, 0, 0, 0, 0 ] while @chamber.size <= @ypos

  @current_rock.size.times do |rock_y|
    inv_y = @current_rock.size - rock_y - 1
    @current_rock[0].size.times do |rock_x|
      p @chamber
      @chamber[@ypos - rock_y][rock_x + @xpos] = 1 if @current_rock[inv_y][rock_x] == 1
    end
  end
end

def solution(input)
  @width = 7
  @chamber = [[1] * 7] * 1
  @xpos = 0
  @ypos = 0

  @rocks = [ 
    [[1, 1, 1, 1]],
    [[0, 1, 0], [1, 1, 1], [0, 1, 0]],
    [[1, 1, 1], [0, 0, 1], [0, 0, 1]],
    [[1], [1], [1], [1]],
    [[1, 1],[1, 1]]
  ]

  @rock_index = 0
  @current_rock = nil

  @step = 0
  direction_index = 0
  2022.times do
    #start rock
    @current_rock = @rocks[@rock_index]
    @xpos = 2
    @ypos = @chamber.size + @current_rock.size + 3 - 1

    print_chamber_with_rock
    p "Current rock: #{@current_rock}"
    #blow wind
    while true
      p "Current rock: #{@current_rock}"
      direction = input.chars[direction_index]
      direction_index = (direction_index + 1) % input.chars.size
      @step = @step + 1
      p "Current rock: #{@current_rock}"
      #make movement if you can
      if direction == "<"
        #puts "moving left?"
        if can_move_left?
          @xpos -= 1
          print_chamber_with_rock
        end
      elsif direction == ">"
        if can_move_right?
          @xpos += 1
          print_chamber_with_rock
        end
      end

      #if it is stuck, break
      break if !can_move_down?

      #move down
      @ypos -= 1
      print_chamber_with_rock
    end

    @rock_index = (@rock_index + 1) % @rocks.size

    persist_rock    
  end

  @current_rock = nil
  print_chamber_with_rock

  ''
end

solution(File.readlines("input0.txt").first)