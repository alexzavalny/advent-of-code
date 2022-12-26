require '../../aoc_utils'

# solution 1
sum = 0
input_lines
  .map(&:to_i)
  .each_with_previous do |c, p|
    sum += 1 if !p.nil? && c > p
  end

puts sum

# solution 2
sum = 0
prev = nil
input_lines
  .map(&:to_i)
  .each_cons(3) do |elements|
    sum += 1 if prev.not_nil? && elements.sum > prev
    prev = elements.sum
  end

puts sum