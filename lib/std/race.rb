require './lib/std/stats'

class Race
  attr_accessor :name, :stats

  def initialize
    @name = self.class.name.to_sym
    @stats = Stats::ALL_STATS.keys.map{ |k| [k, Stats::BASE_STAT]}.to_h
  end

  def self.get_instance(name)
    Object.const_get(name).send(:new)
  end
end
