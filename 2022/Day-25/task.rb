def num_to_snafu(num)
  total = num
  snafu = ""

  while total > 0
    left = total % 5
    total = total / 5

    if left <= 2
      snafu = left.to_s + snafu
    else
      snafu = (left == 4 ? "-" : "=") + snafu
      total += 1
    end
  end
  snafu
end

def snafu_to_num(snafu)
  sum = 0
  snafu.split('').reverse.each_with_index do |d, i|
    pow = 5 ** i
    if d == "="
      sum += -2 * pow
    elsif d == "-"
      sum += -1 * pow
    elsif d == "0"
      sum += 0 * pow
    elsif d == "1"
      sum += 1 * pow
    elsif d == "2"
      sum += 2 * pow
    end
  end
  sum
end

def solution(input)
  sum = input.sum { snafu_to_num(_1.chomp) } 
  puts num_to_snafu(sum)
end

solution(File.readlines("input1.txt", chomp: true))