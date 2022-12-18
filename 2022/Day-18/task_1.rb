cubes = File.readlines("input1.txt").map { |l| l.split(",").map(&:to_i) }

sum = 0

cubes.sum do |cube1|
  s = 6
  cubes.each do |cube2|
    is_sibling = (cube1[0]-cube2[0]).abs + (cube1[1]-cube2[1]).abs + (cube1[2]-cube2[2]).abs == 1
    s -= 1 if is_sibling
  end
  sum += s
end

p sum