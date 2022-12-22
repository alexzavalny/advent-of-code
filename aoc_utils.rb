def wp (s, &b)
  puts "#{s} = #{eval(s.to_s, b.binding)}"
end

class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end

class Array
  def in_groups_of(n)
    self.each_slice(n).to_a
  end
end
