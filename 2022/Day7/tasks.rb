root = { children: [], size: 0 }
path = [root]

File.readlines(ARGV[0], chomp: true).each do |line|
  case line
    when /\$ cd \//, /\$ ls/
    when /dir/ then path.last[:children] << { name: line[4..1000], size: 0, children: [] }
    when /\$ cd \.\./ then path.pop
    when /\$ cd/ then path << path.last[:children].find { _1[:name] == line[5..1000] }
    when /./ then path.last[:size] += line.split(' ')[0].to_i
  end
end

def total_size(dir)
  dir[:size] + dir[:children].sum { total_size(_1) }
end

def find_smaller(dir, max_size)
  small_dirs = dir[:children].select { total_size(_1) <= max_size }
  [small_dirs + dir[:children].map { find_smaller(_1, max_size) }].flatten
end

def find_bigger(dir, min_size)
  big_dirs = dir[:children].select { total_size(_1) >= min_size }
  [big_dirs + dir[:children].map { find_bigger(_1, min_size) }].flatten
end

#task 1 
p find_smaller(root, 100000).sum { total_size(_1) }

# #task 2
need_to_free = 30000000 - (70000000 - total_size(root))
p find_bigger(root, need_to_free).map { total_size(_1) }.min