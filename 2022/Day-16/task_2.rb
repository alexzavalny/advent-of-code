require 'set'
module Day16
  class Solution
    MINUTES_TOTAL = 30
    LOG = false
    PAUSE = false

    def initialize
      @valves = {}
      @best = 0
      @sum_rates = 0
      @max_opened = { }
    end

    def path_to_str(path)
      path.map do |step|
        if step[:action] == :open
          "[open #{step[:place]} (#{ @valves[step[:place]][:rate] })]"
        else
          "[move #{step[:place]} -> #{step[:destination]}]"
        end
      end.join(" ")
    end

    def score(path)
      #puts path.size
      return 0 if path.size == 0

      rez = path.last[:flow]
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
      return false if path.size < 5
      if path.size < MINUTES_TOTAL && score(path) + @sum_rates * (MINUTES_TOTAL - path.size) < @best
        return true
      end
      
      return false
    end

    def best_way(opened, cur_valve, need_open, path)
      return 0 if should_kill(path)
      return score(path) if path.size == MINUTES_TOTAL #we did all we can

      if need_open
        last_flow = path.size > 0 ? path.last[:flow] : 0
        elem = {place: cur_valve, action: :open, opened: opened.clone, flow: last_flow + calculate_flow(opened) } 
        return best_way(opened + [cur_valve], cur_valve, false, path + [elem])
      end

      leads = @valves[cur_valve][:leads]
      leads.each do |way|
        next if should_skip?(path, way)
        last_flow = path.size > 0 ? path.last[:flow] : 0
        elem = {place: cur_valve, action: :move, destination: way, opened: opened.clone, flow: last_flow + calculate_flow(opened)}

        if !opened.include?(way) && @valves[way][:rate] > 0
          best_way(opened, way, true, path + [elem])
        end

        best_way(opened, way, false, path + [elem])
      end
    end

    def run(input)
      keys = []

      ndx = 1

      input.each do |line|
        rate = line.scan(/\d+/).first.to_i
        all_valves = line.scan(/[A-Z][A-Z]/).map(&:to_sym)

        current = all_valves.shift
        keys << current
        @valves[current] = { rate: rate, leads: all_valves, ndx: ndx}
        ndx += 1
      end

      @sum_rates = keys.sum { @valves[_1][:rate] }

      best_way([], :AA, false, [])
      ""
    end
  end
  
end

puts Day16::Solution.new.run(File.readlines("input1.txt"))