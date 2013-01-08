require 'weakref'

module Living
  ALL_LIVINGS = []

  attr_accessor :last_heartbeat

  def self.heartbeat
    start = 0
    finish = ALL_LIVINGS.size
      
    while start < finish do
      begin
        ALL_LIVINGS[start].heartbeat
        start = start + 1
      rescue WeakRef::RefError
        ALL_LIVINGS.delete_at(start)
        finish = finish - 1
      end
    end
  end

  def initialize
    ALL_LIVINGS << WeakRef.new(self)
  end

  def heartbeat
    @last_heartbeat = Time.now
    tick()
  end

  def tick
  end
end
