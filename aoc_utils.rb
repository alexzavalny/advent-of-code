def wp (s, &b)
  puts "#{s} = #{eval(s.to_s, b.binding)}"
end

class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end

class Object
  def not_nil?
    !nil?
  end
end

class Array
  def in_groups_of(n)
    self.each_slice(n).to_a
  end

  def each_with_previous
    prev = nil
    self.each do |current|
      yield current, prev
      prev = current
    end
  end
end

def input(file = :real)
  filename = file == :real ? 'input1.txt' : 'input0.txt'
  File.read(filename)
end

def input_lines(file = :real)
  input(file).split("\n").map(&:chomp)
end