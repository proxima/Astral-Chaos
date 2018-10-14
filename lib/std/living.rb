require './driver/std/base'

class Living < Mud::Object
  def initialize
    super
  end

  def heartbeat
    tick
  end

  def tick
  end

  def say_hi(*args)
    puts "Hello, World!"
  end
end
