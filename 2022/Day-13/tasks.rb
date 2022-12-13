def compare(l, r) 
  return l <=> r if [l, r].all? { _1.is_a?(Integer) }

  l, r = Array(l), Array(r)

  [l, r].map(&:size).min.times do |i|
    rez = compare(l[i], r[i])
    return rez unless rez.zero?
  end

  l.size <=> r.size
end

def solution1(input)
  input
    .split("\n\n")
    .map { |p| p.split("\n").map { |line| eval(line) } }
    .each_with_index
    .sum do |(l, r), index|
      (compare(l, r) == 1 ? 0 : index.succ )
    end
end

def solution2(input)
  input # Shamelessly took the tap and then from Nikita
    .split("\n")
    .reject(&:empty?)
    .map { |packet| eval(packet) }
    .tap { |packets| packets.push([[2]], [[6]]) }
    .sort { |a, b| compare(a, b) }
    .then { |sorted| sorted.index([[2]]).succ * sorted.index([[6]]).succ }
end

puts solution1(File.read("input0.txt"))
puts solution2(File.read("input0.txt"))
puts solution1(File.read("input1.txt"))
puts solution2(File.read("input1.txt"))