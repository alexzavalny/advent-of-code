cubes = File.readlines("input1.txt").map { |l| l.split(",").map(&:to_i) }

def are_siblings?(cube1, cube2)
  (cube1[0]-cube2[0]).abs + (cube1[1]-cube2[1]).abs + (cube1[2]-cube2[2]).abs == 1
end

def calculate_surface(cubes)
  sum = 0

  cubes.sum do |cube1|
    s = 6
    cubes.each do |cube2|
      s -= 1 if are_siblings?(cube1, cube2)
    end
    sum += s
  end

  sum
end

sum = calculate_surface(cubes)

p "Answer 1", sum

aircubes = []

(-1..20).each do |x|
  (-1..20).each do |y|
    (-1..20).each do |z|
      aircubes << [x, y, z]
    end
  end
end

aircubes = aircubes - cubes

que = [ [1, 1, 1 ]]
while que.size > 0
  i = aircubes.size - 1
  current = que.shift

  while i > -1
    consider = aircubes[i]
    if are_siblings?(current, consider)
      que << consider
      aircubes.delete_at(i)
    end
    i = i - 1
  end
end

inner_air = calculate_surface(aircubes)

puts "Answer 2" 
puts "#{sum - inner_air}"