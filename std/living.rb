class Living
  def self.all
    ObjectSpace.each_object(self).to_a
  end

  attr_accessor :last_heartbeat

  def self.heartbeat
    Living::all.each do |liv|
      liv.heartbeat
    end
  end

  def initialize
  end

  def heartbeat
    @last_heartbeat = Time.now
    tick()
  end

  def tick
  end
end
