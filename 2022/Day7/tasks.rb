root = { folders: [], size: 0 }
path = [root]

File.readlines(ARGV[0], chomp: true).each do |str|
  case str
    when /\$ cd \//, /\$ ls/
    when /dir/ then path.last[:folders] << { name: str.split()[1], size: 0, folders: [] }
    when /\$ cd \.\./ then path.pop
    when /\$ cd/ then path << path.last[:folders].find { _1[:name] == str.split()[2] }
    when /./ then path.last[:size] += str.split()[0].to_i
  end
end

def total_size(dir)
  dir[:size] + dir[:folders].sum { total_size(_1) }
end

def sizes(dir)
  under = dir[:folders].map { sizes(_1) }
  [total_size(dir), under].flatten
end

puts "Task 1: #{ sizes(root).select { _1 < 100000 }.sum }"

# #task 2
need_to_free = 30000000 - (70000000 - total_size(root))
puts "Task 2: #{ sizes(root).select { _1 >= need_to_free }.min }"
