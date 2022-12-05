input = File.readlines(ARGV[0], chomp: true)
COUNT = (input[0].length + 1)/4
task = ARGV[1].to_i

stacks = Array.new(COUNT) { [] }
commands = []
mode = "reading_crates"

input.each do |line|
  next if line.start_with?(" 1")

  if mode == "reading_crates"
    (0...COUNT).each do |ndx|
      crate = line.chars[ndx * 4 + 1].to_s.strip
      stacks[ndx] << crate if !crate.empty?
    end
  end
  
  if mode == "reading_moves"
    nums = line.scan(/\d+/).map(&:to_i)
    commands << { count: nums[0], from: nums[1] - 1, to: nums[2] - 1}
  end

  mode = "reading_moves" if line.empty?
end

if task == 1
  commands.each do |cmd|
    cmd[:count].times { 
      stacks[cmd[:to]].unshift(stacks[cmd[:from]].shift)
    }
  end
end

if task == 2
  commands.each do |cmd|
    stacks[cmd[:to]].unshift(stacks[cmd[:from]].shift(cmd[:count])).flatten!
  end
end

p "Code: #{ stacks.map(&:first).join }"