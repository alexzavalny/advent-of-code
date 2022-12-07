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

def find_smaller(dir, max_size)
  small_dirs = dir[:folders].select { total_size(_1) <= max_size }
  [small_dirs + dir[:folders].map { find_smaller(_1, max_size) }].flatten
end

def find_bigger(dir, min_size)
  big_dirs = dir[:folders].select { total_size(_1) >= min_size }
  [big_dirs + dir[:folders].map { find_bigger(_1, min_size) }].flatten
end

#task 1 
p find_smaller(root, 100000).sum { total_size(_1) }

# #task 2
need_to_free = 30000000 - (70000000 - total_size(root))
p find_bigger(root, need_to_free).map { total_size(_1) }.min
