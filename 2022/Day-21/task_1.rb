eval(File.readlines("input1.txt", chomp: true).map do |l|
  code = "def " + l
  code.sub!(":", ";")
  code << "; end;\n"
end.join)

puts root
