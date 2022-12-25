def num_to_snafu(num)
  snafu = ""

  while num > 0
    left = num % 5
    num = num / 5
    snafu = "012=-"[left] + snafu
    num += 1 if left > 2 # this is the magic line. to my shame, I did it somewhat by trying out different numbers.
  end

  snafu
end

def snafu_to_num(snafu)
  snafu.split('').reverse.each_with_index.sum do |d, i|
    pow = 5 ** i
    ("=-012".index(d) - 2) * pow
  end
end

def solution(input)
  sum = input.sum { snafu_to_num(_1.chomp) } 
  puts num_to_snafu(sum)
end

solution(File.readlines("input1.txt", chomp: true))