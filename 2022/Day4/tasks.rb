require 'set'

input = File.readlines(ARGV[0])

p(input.count do
  par = _1.split(",").map { |x| x.split("-").map(&:to_i).inject { |s,e| Set.new(s.to_i..e.to_i) } }
  [par[0], par[1]].include?(par[0] & par[1])
end)

p(input.count do
  par = _1.split(",").map { |x| x.split("-").map(&:to_i).inject { |s,e| Set.new(s.to_i..e.to_i) } }
  !(par[0] & par[1]).empty?
end)
