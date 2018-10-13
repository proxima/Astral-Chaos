require 'weakref'

module Mud
  module Efun
    def self.base_name(ob)
      ob.class.name
    end

    def self.object_name(ob)
      ob.class.name + '#' + ob.object_id.to_s
    end
  end

  class Object
    @@objects = {}

    def initialize
      @@objects[Efun::object_name(self)] = WeakRef.new(self)
    end

    def self.find(path)
      begin
        @@objects[path].__getobj__ if @@objects[path]
      rescue WeakRef::RefError
        @@objects.delete(path)
        nil
      end
    end

    def self.keys
      @@objects.select! { |k,v| v.weakref_alive? }
      @@objects.keys
    end

    def self.values
      @@objects.select! { |k,v| v.weakref_alive? }
      @@objects.values
    end

    private
    attr_accessor :environment
  end

  module Efun
    def self.find_object(path)
      Object::find(path)
    end
  end
end
