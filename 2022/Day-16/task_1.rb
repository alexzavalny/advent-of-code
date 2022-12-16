require 'set'
module Day16
  class Solution
    MINUTES_TOTAL = 30
    LOG = false
    PAUSE = false

    def initialize
      @valves = {}
      @visited = Set[]
      @best = 0
      @sum_rates = 0
    end

    def path_to_str(path)
      path.map do |step|
        if step[:action] == :open
          "[open #{step[:place]}]"
        else
          "[move #{step[:place]} -> #{step[:destination]}]"
        end
      end.join(" ")
    end

    def score(path)
      #puts path
      rez = path.sum { _1[:flow] }
      puts "Result of scoring: #{rez}" if LOG
      puts if LOG
      if rez > @best
        puts "Scoring #{ path_to_str(path) }"
        puts "New best: #{rez}"
        @best = rez
      end

      return rez
    end

    def should_skip?(path, way)
      i = path.size - 1
      while i >= 0
        return false if path[i][:action] == :open
        return true if path[i][:place] == way
        i -= 1
      end

      return false
    end

    def calculate_flow(opened)
      opened.sum { @valves[_1][:rate] }
    end

    def should_kill(path)
      if path.size < MINUTES_TOTAL && score(path) + @sum_rates * (MINUTES_TOTAL - path.size) < @best
        return true
      end
      
      return false
    end

    def best_way(opened, cur_valve, need_open, path)
      @visited << cur_valve

      return 0 if should_kill(path)
      return score(path) if path.size == MINUTES_TOTAL #we did all we can
      
      if need_open
        path << {place: cur_valve, action: :open, opened: opened.clone, flow: calculate_flow(opened) } 
        opened = opened.dup
        opened << cur_valve
        return best_way(opened, cur_valve, false, path)
      end

      scores = [0]

      @valves[cur_valve][:leads].each do |way|
        next if should_skip?(path, way)
        path2 = path.dup
        path2 << {place: cur_valve, action: :move, destination: way, opened: opened.clone, flow: calculate_flow(opened)}

        if !opened.include?(way) && @valves[way][:rate] > 0
          scores << best_way(opened.clone, way, true, path2.dup)
        end

        scores << best_way(opened.clone, way, false, path2.dup)
      end

      return scores.max
    end

    def run(input)
      keys = []

      input.each do |line|
        rate = line.scan(/\d+/).first.to_i
        all_valves = line.scan(/[A-Z][A-Z]/)
        current = all_valves.shift
        keys << current
        @valves[current] = { rate: rate, leads: all_valves}
      end

      # keys.each do |key|
      #   @valves[key][:leads].sort! { |a, b| @valves[b][:rate] <=> @valves[a][:rate] }
      # end
      @sum_rates = keys.sum { @valves[_1][:rate] }

      pp @valves

      best_way(Set[], "AA", false, []).to_s
      puts "Visited: #{@visited}"
    end
  end
end

puts Day16::Solution.new.run(File.readlines("input0.txt"))