max_calories = 0
current_deer = 0

IO.foreach("input1.txt") do |x| 
  x.chomp!

  if x.empty?
    max_calories = current_deer if current_deer > max_calories
    current_deer = 0
  else
    current_deer += x.to_i
  end
end

puts max_calories