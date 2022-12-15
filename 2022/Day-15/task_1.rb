require 'interval_set' # I am not proud of this.

def solution(input, free_line)
  sensors = []

  most_left = 10_000_000
  most_right = -10_000_000

  input.map { _1.scan(/\d+/).map(&:to_i) }.each do |l|
    sensor = {
      pos: [l[0], l[1]],
      beak: [l[2], l[3]]
    }
    sensor[:distance] = (sensor[:pos][0] - sensor[:beak][0]).abs + (sensor[:pos][1] - sensor[:beak][1]).abs
    most_left = [most_left, sensor[:pos][0] - sensor[:distance]].min
    most_right = [most_right, sensor[:pos][0] + sensor[:distance]].max
    sensors << sensor
  end

  covered_intervals = []

  iii = IntervalSet[]
  pp ["Count", iii.count]

  sensors.each do |sensor|
    y_pos = sensor[:pos][1]
    x_pos = sensor[:pos][0]
    tail = 0

    if free_line > y_pos
      tail = (y_pos + sensor[:distance]) - free_line
    else
      tail = free_line - (y_pos - sensor[:distance])
    end

    if tail  > 0
      covered_intervals << [x_pos-tail, x_pos+tail]
      iii << (x_pos-tail .. x_pos+tail)
    end

  end

  p ["Count", iii.count]
  p ["Bounds", iii.bounds]
  p covered_intervals

  #pp sensors
  #pp ["most_left", most_left]
  #pp ["most_right", most_right]
  ''
end

#puts solution(File.readlines("input0.txt"), 10)
puts solution(File.readlines("input1.txt"), 2000000)

p (1095773 + 4415428)