require './std/living.rb'
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
  def test_living_garbage_collection
    pc = PC.new
    npc = NPC.new
    
    Living::heartbeat
    assert_equal(Living::all.size, 2)
 
    pc = nil
    ObjectSpace.garbage_collect
    Living::heartbeat
    assert_equal(Living::all.size, 1)

    npc = nil
    ObjectSpace.garbage_collect
    Living::heartbeat
    assert_equal(Living::all.size, 0)
  end

  def test_living_times_are_updated
    pc = PC.new
    
    Living::heartbeat
    t1 = pc.last_heartbeat
    
    sleep(1)

    Living::heartbeat
    t2 = pc.last_heartbeat
  
    assert_operator t1, :<, t2
  end

  def test_tick
    npc = NPC.new
    Living::heartbeat

    assert_equal(npc.tick_was_called, true)
  end

  def test_tick_performance
    npcs = []
    5000.times { npcs << NPC.new }

    RubyProf.start
    Living::heartbeat
    result = RubyProf.stop
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT)
  end
end
