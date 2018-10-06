class Living
  def self.all
    ObjectSpace.each_object(self).to_a
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
