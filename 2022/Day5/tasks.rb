task = ARGV[1].to_i # 1 or 2
stacks = []
input = File.open(ARGV[0],"r")

while line = input.gets.chomp
  next if line.start_with?(" 1")
  break if line.empty?

  (1...line.size).step(4) do |ndx|
    crate = line.chars[ndx].to_s.strip
    stacks[ndx / 4] ||= []
    stacks[ndx / 4] << crate if !crate.empty?
  end
end

while line = input.gets
  nums = line.scan(/\d+/).map(&:to_i)
  taken = stacks[nums[1] - 1].shift(nums[0])
  stacks[nums[2] - 1].unshift(task == 1 ? taken.reverse : taken).flatten!
end

p "Code: #{ stacks.map(&:first).join }"
