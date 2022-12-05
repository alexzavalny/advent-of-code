p File.readlines(ARGV[0]).sum {
  l, r = _1.chars.each_slice(_1.length / 2).to_a
  c = (l & r)[0].ord
  c - (c < 91 ? 38 : 96)
}

p File.readlines(ARGV[0]).map(&:chars).each_slice(3).sum {
  c = _1.reduce(:&)[0].ord
  c - (c < 91 ? 38 : 96)
}
