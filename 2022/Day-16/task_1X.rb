#shamelessly stolen from friend Erik, rewritten and optimized

require 'set'
module Day16
  class Solution
    MINUTES_TOTAL = 26

    def initialize
      @valves = {}
      @best = 0
      @max_opened = { }
      @useful = []
      @sums = [0]
    end

    def calculateDistances(valve)
      q = [valve]
      while q.length > 0
        current = q.shift;
        current[:leads].each do |lead|
          @valves[lead][:distances] ||= {}
          if @valves[lead][:distances][valve[:id]].nil?
            @valves[lead][:distances][valve[:id]] = current[:distances][valve[:id]] + 1
            q << @valves[lead]
          end
        end
      end #while
    end

    def go(cur_keys, unopened, sum, times)
      cur_key1, cur_key2 = cur_keys
      time1, time2 = times

      unopened.each do |key1|
        sum1 = sum
        time1_bak = time1
        candidate1 = nil

        v1 = @valves[key1]
        dist1 = v1[:distances][cur_key1]

        if (!cur_key1.nil? && !dist1.nil? && dist1 + time1_bak + 1 < MINUTES_TOTAL)
          candidate1 = key1
          sum1 += (MINUTES_TOTAL - dist1 - time1_bak - 1) * v1[:rate]
          time1_bak += dist1 + 1
        end

        ([''] + unopened).each do |key2|
          time2_bak = time2
          sum2 = sum1
          candidate2 = nil
  
          v2 = @valves[key2] unless key2.empty?
          dist2 = v2[:distances][cur_key2] unless v2.nil?
          if (!cur_key2.nil? && !dist2.nil? && dist2 + time2_bak + 1 < MINUTES_TOTAL && key1 != key2)
            candidate2 = key2
            sum2 += (MINUTES_TOTAL - dist2 - time2_bak - 1) * v2[:rate]
            time2_bak += dist2 + 1
          end

          if !candidate1.nil? || !candidate2.nil?
            real_unopened = unopened.reject { _1 == candidate1 || _1 == candidate2 }
            go([candidate1, candidate2], real_unopened, sum2, [time1_bak, time2_bak])
          end
        end
        # break if candidate1.nil?
      end

      if sum > @sums.max
        @sums.push(sum) 
        pp sum, @useful - unopened
      end
    end

    def run(input)

      input.each do |line|
        rate = line.scan(/\d+/).first.to_i
        all_valves = line.scan(/[A-Z][A-Z]/).map(&:to_sym)

        current = all_valves.shift
        @useful << current unless rate.zero?
        @valves[current] = { id: current, rate: rate, leads: all_valves, distances: { }}
        @valves[current][:distances][current] = 0
      end

      @valves.each_value { calculateDistances(_1) }

      go([:AA, :AA], @useful, 0, [0, 0])
      
      pp @sums.max
      ""
    end
  end
  
end

require 'benchmark'

Day16::Solution.new.run(File.readlines("input0.txt")) 
