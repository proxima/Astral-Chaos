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
end
