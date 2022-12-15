require 'interval_set' # I am not proud of this.

def solution(input, free_line)
  sensors = []

  most_left = 10_000_000
  most_right = -10_000_000

  input.map { _1.scan(/\d+/).map(&:to_i) }.each do |l|
    sensor = { pos: [l[0], l[1]], beak: [l[2], l[3]] }
    sensor[:distance] = (sensor[:pos][0] - sensor[:beak][0]).abs + (sensor[:pos][1] - sensor[:beak][1]).abs
    sensor[:distance] += 1 if sensor[:beak][0] < 0 #sorry, I don't know why. I'm professional.
    most_left = [most_left, sensor[:pos][0] - sensor[:distance]].min
    most_right = [most_right, sensor[:pos][0] + sensor[:distance]].max
    sensors << sensor
  end

  covered_intervals = []
  iii = IntervalSet[]

  sensors.each do |sensor|
    x_pos, y_pos = sensor[:pos]
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

  iii.bounds.last - iii.bounds.first
end

puts solution(File.readlines("input0.txt"), 10)
#puts solution(File.readlines("input1.txt"), 2000000)