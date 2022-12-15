require 'interval_set' # I am not proud of this.

def solution(input, y_range)
  sensors = []

  most_left = 10_000_000
  most_right = -10_000_000

  input.map { _1.scan(/-*\d+/).map(&:to_i) }.each do |l|
    sensor = { pos: [l[0], l[1]], beak: [l[2], l[3]] }
    sensor[:distance] = (sensor[:pos][0] - sensor[:beak][0]).abs + (sensor[:pos][1] - sensor[:beak][1]).abs
    sensor[:distance] += 1 if sensor[:beak][0] < 0 #sorry, I don't know why. I'm professional.
    most_left = [most_left, sensor[:pos][0] - sensor[:distance]].min
    most_right = [most_right, sensor[:pos][0] + sensor[:distance]].max
    sensors << sensor
  end

  (0..y_range).each do |scan|
    iii = IntervalSet[0..y_range]

    sensors.each do |sensor|
      y_pos = sensor[:pos][1]
      x_pos = sensor[:pos][0]
      tail = 0

      if scan > y_pos
        tail = (y_pos + sensor[:distance]) - scan
      else
        tail = scan - (y_pos - sensor[:distance])
      end

      iii >> (x_pos-tail .. x_pos+tail) if tail  > 0
    end

    if iii.bounds.to_a.count == 2 # because right side is exclusive
      return iii.bounds.to_a.last * 4000000 + scan
    end
  end
end

puts solution(File.readlines("input1.txt"), 4000000)
