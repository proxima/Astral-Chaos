require './driver/std/mud_object'

class Living
  def self.all
    MudObject.values.collect { |ob| ob.is_a?(self) }
  end

  def self.size
    return all.size
  end

  attr_accessor :last_heartbeat

  def initialize
  end

  def heartbeat
    @last_heartbeat = Time.now
    tick
  end

  def tick
  end
end
