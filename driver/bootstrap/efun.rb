module Efun
  private
  def base_name(ob)
    ob.class.name
  end

  def object_name(ob)
    ob.class.name + '#' + ob.object_id.to_s
  end

  def find_object(path)
    ObjectSpace._id2ref(path.split(/#/)[1].to_i)
  end
end

class Object
  extend Efun
  include Efun
end
