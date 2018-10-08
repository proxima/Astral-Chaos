require './lib/std/stats'

class Race
  attr_accessor :name, :stats

  def initialize
    @name = self.class.name.to_sym
    @stats = Stats::ALL_STATS.keys.map{ |k| [k, Stats::BASE_STAT]}.to_h
  end
end
