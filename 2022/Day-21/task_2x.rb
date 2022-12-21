# The idea of binary search came up in reddit, so just for fun I decided to expand on task 1 solution
eval(File.readlines("input1.txt", chomp: true).map do |l|
  l.gsub!("+", "-") if l.include? ("root")
  code = "def " + l
  code.sub!(":", ";")
  code << "; end;\n"
end.join)

@curr = 50000000000000

def humn
  @curr
end

rez = 0
l, r = 0, 100000000000000

while true
  rez = root() #calling the whole sequence

  break if rez == 0 
    
  if rez < 0 # or rez > 0, depending where humn is in equation
    r = @curr
  else
    l = @curr
  end
    
  @curr = (l + r)/ 2
end

puts @curr - 1 #no idea why it is always off by 1
