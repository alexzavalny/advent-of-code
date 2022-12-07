root = { folders: [], size: 0 }
path = [root]
sizes = {}
File.readlines(ARGV[0], chomp: true).each do |str|
  case str
    when /\$ cd \//, /\$ ls/
    when /dir/ then path.last[:folders] << { name: str.split()[1], size: 0, folders: [] }
    when /\$ cd \.\./ then path.pop
    when /\$ cd/ then path << path.last[:folders].find { _1[:name] == str.split()[2] }
    when /./ then path.each { _1[:size] += str.split()[0].to_i }
  end
end

def flatten_sizes(dir)
  [dir[:size], dir[:folders].map { flatten_sizes(_1) }].flatten
end

sizes = flatten_sizes(root)
puts "Task 1: #{ sizes.select { _1 < 10**5 }.sum }"
puts "Task 2: #{ sizes.select { _1 >= sizes[0] - 40000000 }.min }"
