require './driver/std/base'

class Living
  def self.all
    Mud::Object.values.collect { |ob| ob.is_a?(self) }
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
