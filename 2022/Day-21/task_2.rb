@monkeys = {}

File.readlines("input0.txt", chomp: true).map do |l|
  monkey = {}
  parts = l.split(":")
  eq = parts[1][1..-1]
  if eq.length < 5
    monkey = { value: eq.to_i }
  else
    eq_parts = eq.split(' ')
    eq_parts[1] = "=" if eq_parts[0] == "root"
    monkey = { left: eq_parts[0], op: eq_parts[1], right: eq_parts[2] }
  end
  @monkeys[parts[0]] = monkey
end

def build_equation(name)
  monkey = @monkeys[name]
  return "x" if name == "humn"
  if monkey[:value]
    return monkey[:value]
  else
    left_val = build_equation(monkey[:left])
    right_val = build_equation(monkey[:right])
    eq = "( #{left_val} #{monkey[:op]} #{right_val} )"
    if !eq.include?("x")
      return eval(eq).to_i
    else
      return { left: left_val, op: monkey[:op], right: right_val }
    end
  end
end

def print_eq(eq, level = 0)
  return eq if eq.class.to_s == "Integer"
  return eq if eq == "x"
  new_level = 0
  new_level = 1 if eq[:op] == "="
  if level == 1
    return "( #{print_eq(eq[:left], new_level)} ___#{eq[:op]}___ #{print_eq(eq[:right], new_level)} )"
  else
    return "( #{print_eq(eq[:left], new_level)} #{eq[:op]} #{print_eq(eq[:right], new_level)} )"
  end
end

eq = build_equation("root")

while (eq[:left] != "x")
  p print_eq(eq)
  puts

  if eq[:left][:op] == "+" 
    v = 0
    if eq[:left][:left].class.to_s == "Integer"
      v = eq[:left][:left]
      eq[:left] = eq[:left][:right]
    else
      v = eq[:left][:right]
      eq[:left] = eq[:left][:left]
    end
    
    eq[:right] = eq[:right] - v
    next
  end

  if eq[:left][:op] == "-"
    v = 0
    if eq[:left][:left].class.to_s == "Integer"
      v = eq[:left][:left]
      eq[:left] = eq[:left][:right]
      eq[:right] = v - eq[:right]
    else
      v = eq[:left][:right]
      eq[:left] = eq[:left][:left]
      eq[:right] = eq[:right] + v
    end

    next
  end

  if eq[:left][:op] == "*"
    v = 0
    if eq[:left][:left].class.to_s == "Integer"
      v = eq[:left][:left]
      eq[:left] = eq[:left][:right]
    else
      v = eq[:left][:right]
      eq[:left] = eq[:left][:left]
    end
    eq[:right] = eq[:right] / v
    next
  end

  if eq[:left][:op] == "/"
    v = 0
    if eq[:left][:left].class.to_s == "Integer"
      v = eq[:left][:left]
      eq[:left] = eq[:left][:right]
      eq[:right] = v / eq[:right]
    else #no problem here
      v = eq[:left][:right]
      eq[:left] = eq[:left][:left]
      eq[:right] = eq[:right] * v
    end

    next
  end
end
p print_eq(eq)
