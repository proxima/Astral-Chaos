class Race
  attr_accessor :name
  attr_accessor :stats

  ALL_STATS = { :str => "Strength", :dex => "Dexterity", :wis => "Wisdom", :int => "Intelligence", :con => "Constitution" }
  BASE_STAT = 20

  def initialize
    @name = self.class.name.to_sym
    @stats = {}

    ALL_STATS.each_pair {|k,v| @stats[k] = BASE_STAT}
  end

  def self.get_instance(name)
    Object.const_get(name).send(:new)
  end
end
