require './driver/std/base'
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

  def test_livings_respond_to_heartbeat
    pc = PC.new
    assert(pc.respond_to?(:heartbeat))
    npc = NPC.new
    assert(npc.respond_to?(:heartbeat))
  end

  def test_livings_become_mud_objects
    pc = PC.new
    assert(Mud::Object.values.include?(pc))
  end

  def test_tick
    npc = NPC.new
    npc.heartbeat

    assert_equal(npc.tick_was_called, true)
  end
end
