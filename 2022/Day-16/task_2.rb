class Array
  def avg
    (self[0] + self[1])/2
  end

  def all_splits_in_2
    return [] if self.size == 0
    return [ [Array(self),[]] , [[], Array(self) ] ] if self.size == 1
    head, *tail = self

    tail.all_splits_in_2.reduce([]) do |new_combos, combo|
      new_combos << [ [head, *combo[0]], combo[1] ]
      new_combos << [ combo[0], [head, *combo[1]] ]
    end
  end

  def half
    return self[0...self.size/2]
  end
end
module Day16
  class Solution
    MINUTES_TOTAL = 26

    def initialize
      @valves = {}
      @useful = []
      @sum_max = 0
      @max_flow = 0
    end

    def calculateDistances(valve)
      to_process = [valve]
      while to_process.length > 0
        current = to_process.shift;
        current[:leads].each do |lead|
          @valves[lead][:distances] ||= {}
          if @valves[lead][:distances][valve[:id]].nil?
            @valves[lead][:distances][valve[:id]] = current[:distances][valve[:id]] + 1
            to_process << @valves[lead]
          end
        end
      end #while
    end

    @cache = {}

    def go(cur_key, closed, sum, time)
      closed.each do |closed_key|
        attempt_sum = sum
        attempt_time = time
        attempt_way = @valves[closed_key]
        dist = attempt_way[:distances][cur_key]

        if (!dist.nil? && dist + attempt_time + 1 < MINUTES_TOTAL)
          attempt_sum += (MINUTES_TOTAL - dist - attempt_time - 1) * attempt_way[:rate]
          attempt_time += dist + 1
          @sum_max = attempt_sum if attempt_sum > @sum_max
          go(closed_key, closed - [closed_key], attempt_sum, attempt_time)
        end
      end
    end

    def run(input)
      input.each do |line|
        rate = line.scan(/\d+/).first.to_i
        all_valves = line.scan(/[A-Z][A-Z]/).map(&:to_sym)
        current = all_valves.shift
        @useful << current unless rate.zero?
        @max_flow += rate
        @valves[current] = { id: current, rate: rate, leads: all_valves, distances: { }}
        @valves[current][:distances][current] = 0
      end

      @valves.each_value { calculateDistances(_1) }
      useful_combos = @useful.all_splits_in_2
      le_sum = 0

      useful_combos.each_with_index do |(l, r), ndx|

        puts "Processing #{ndx + 1} out of #{useful_combos.size}. Max results is #{le_sum}" if ndx % 100 ==0 
        @sum_max = 0
        @sumsum = 0
        go(:AA, l, 0, 0)
        @sumsum = @sum_max
        @sum_max = 0
        go(:AA, r, 0, 0)
        @sumsum += @sum_max
        le_sum = @sumsum if @sumsum > le_sum
      end
      
      puts "Results is #{le_sum}"
      ""
    end
  end
  
end

require 'benchmark'
puts Benchmark.measure {
  Day16::Solution.new.run(File.readlines("input1.txt")) 
}