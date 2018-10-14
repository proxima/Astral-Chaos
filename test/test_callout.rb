require 'eventmachine'
require 'test/unit'

require './driver/std/base'

Thread.new { EventMachine.run }

class TestCallout < Test::Unit::TestCase
  class C < Mud::Object
    def self.MAGIC_NUMBER
      12345
    end

    attr_accessor :args
    attr_accessor :arg1, :arg2

    def initialize
      super
      Mud::Efun::call_out(0.1, self, :set_called, C.MAGIC_NUMBER, C.MAGIC_NUMBER)
      Mud::Efun::call_out(0.1, self, :set_called2, C.MAGIC_NUMBER, C.MAGIC_NUMBER)
    end

    def set_called(*args)
      @args = args
    end

    def set_called2(arg1, arg2)
      @arg1 = arg1
      @arg2 = arg2
    end
  end

  def test_exception_in_callout_doesnt_cause_crash
    assert(EventMachine.reactor_running?)

    $stderr = File.new(File.join(File.dirname(__FILE__), 'dev', 'null.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), 'dev', 'null.txt'), 'w')

    Mud::Efun::call_out(0.1) do
      raise 'An Error!'
    end

    Mud::Efun::call_out(0.2) do
      assert(EventMachine.reactor_running?)
    end

    sleep 0.3
  end

  def test_object_usage
    assert(EventMachine.reactor_running?)

    c = C.new

    Mud::Efun::call_out(0.2) do
      assert(EventMachine.reactor_running?)
      assert_equal(c.args.size, 2)
      assert_equal(c.args[0], C.MAGIC_NUMBER)
      assert_equal(c.args[1], C.MAGIC_NUMBER)
      assert_equal(c.arg1, C.MAGIC_NUMBER)
      assert_equal(c.arg2, C.MAGIC_NUMBER)
    end

    sleep 0.3
  end
end
