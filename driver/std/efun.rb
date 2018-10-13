require './driver/std/mud_object'

module Efun
  def self.base_name(ob)
    ob.class.name
  end

  def self.object_name(ob)
    ob.class.name + '#' + ob.object_id.to_s
  end

  def self.find_object(path)
    MudObject::find(path)
  end
end
