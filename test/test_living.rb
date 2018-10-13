require './lib/std/living'
require 'ruby-prof'
require 'test/unit'

class PC < Living
end

class NPC < Living
  attr_accessor :tick_was_called

  def initialize
    super
    @tick_was_called = false
  end

  def tick
    @tick_was_called = true
  end
end

class TestLiving < Test::Unit::TestCase
  def test_living_times_are_updated
    pc = PC.new
    
    pc.heartbeat
    t1 = pc.last_heartbeat

    sleep(0.001)
    pc.heartbeat
    t2 = pc.last_heartbeat
  
    assert_operator t1, :<, t2
  end

  def test_tick
    npc = NPC.new
    npc.heartbeat

    assert_equal(npc.tick_was_called, true)
  end
end
