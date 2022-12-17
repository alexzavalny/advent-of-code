#shamelessly stolen from friend, rewritten and optimized, cut out wrong ways, and then shuffle gave the result
# i will return to this, because it's awful
class Array
  def avg
    (self[0] + self[1])/2
  end
end

require 'set'
module Day16
  class Solution
    MINUTES_TOTAL = 26
    LIMIT = 25
    def initialize
      @valves = {}
      @max_opened = { }
      @useful = []
      @sum_max = 0#2100
      @max_flow = 0
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

    def should_skip?(time, sum, max_flow_left)
      time_left = MINUTES_TOTAL - time
      return false if time_left < 1
      return false if time < 2
      return true if sum + (time_left) * max_flow_left < @sum_max #still worst than our best
      return false
    end

    def go(cur_keys, unopened, sum, times, max_flow_left)
      cur_key1, cur_key2 = cur_keys
      time1, time2 = times

      unopened.each do |key1|
        sum1 = sum
        time1_bak = time1
        candidate1 = nil

        v1 = @valves[key1]
        dist1 = v1[:distances][cur_key1]

        if (!cur_key1.nil? && !dist1.nil? && dist1 + time1_bak + 1 < LIMIT)
          candidate1 = key1
          sum1 += (MINUTES_TOTAL - dist1 - time1_bak - 1) * v1[:rate]
          time1_bak += dist1 + 1

          # real_unopened = unopened.reject { _1 == candidate1 }
          #go([candidate1, nil], real_unopened, sum1, [time1_bak, time2])
        end

        unopened.shuffle.each do |key2|
          time2_bak = time2
          sum2 = sum1
          candidate2 = nil
  
          v2 = @valves[key2] unless key2.empty?
          dist2 = v2[:distances][cur_key2] unless v2.nil?
          if (!cur_key2.nil? && !dist2.nil? && dist2 + time2_bak + 1 < LIMIT && key1 != key2)
            candidate2 = key2
            sum2 += (MINUTES_TOTAL - dist2 - time2_bak - 1) * v2[:rate]
            time2_bak += dist2 + 1
          end

          if !candidate1.nil? || !candidate2.nil? && time2_bak < time1_bak
            real_unopened = unopened.reject { _1 == candidate1 || _1 == candidate2 }
            max_flow_left2 = max_flow_left
            max_flow_left2 -= v1[:rate] if !v1.nil? && v1[:rate] > 0
            max_flow_left2 -= v2[:rate] if !v2.nil? && v2[:rate] > 0 && key1 != key2
            if sum2 > @sum_max
              @sum_max = sum2
              puts "Max sum: #{sum2} Flow left: #{max_flow_left2}"
            end
            return if should_skip?([time1_bak, time2_bak].min, sum2, max_flow_left2)
            go([candidate1, candidate2], real_unopened, sum2, [time1_bak, time2_bak], max_flow_left2)
          end
        end
        # break if candidate1.nil?
      end

      if sum > @sum_max
        @sums_max = sum
        p @sum_max
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

      #@useful.sort! { |a, b| @valves[b][:rate] <=> @valves[a][:rate]}
      #p @useful
      #gets

      @valves.each_value { calculateDistances(_1) }

      go([:AA, :AA], @useful, 0, [0, 0], @max_flow)
      
      p @sums_max
      ""
    end
  end
  
end

require 'benchmark'
puts Benchmark.measure {
  Day16::Solution.new.run(File.readlines("input0.txt")) 
}
