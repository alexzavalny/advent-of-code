def solution(input)
  monkeys_instructions = input.split("\n\n").map { _1.split("\n" )}

  monkeys = monkeys_instructions.map do |inst|
    {
      items: inst[1].scan(/\d+/),
      operation: inst[2][23..-1].split, #+ 3, * old, etc
      divisible:  inst[3].scan(/\d+/)[0].to_i,
      throw_true: inst[4].scan(/\d+/)[0].to_i,
      throw_false: inst[5].scan(/\d+/)[0].to_i,
      inspected: 0
    }
  end

  global_div = monkeys.map { |m| m[:divisible] }.reduce(:*)

  10_000.times do |round|
    monkeys.each do |monkey|
      monkey[:items].size.times do 
        item = monkey[:items].slice!(0).to_i
        prev = monkey[:operation][1] == "old" ? item : monkey[:operation][1].to_i

        item = item.send(monkey[:operation][0], prev)
        item %= global_div
      
        if item % monkey[:divisible] == 0
          monkeys[monkey[:throw_true]][:items] << item
        else
          monkeys[monkey[:throw_false]][:items] << item
        end

        monkey[:inspected] += 1
      end
    end
  end

  
  monkeys.map { |m| m[:inspected] }.max(2).reduce(:*)
end

#puts solution(File.read("input0.txt", chomp: true))
#10605
puts solution(File.read("input1.txt", chomp: true))

