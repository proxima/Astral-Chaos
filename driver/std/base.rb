require 'eventmachine'
require 'weakref'

module Mud
  module Efun
    def self.base_name(ob)
      ob.class.name
    end

    def self.object_name(ob)
      ob.class.name + '#' + ob.object_id.to_s
    end

    def self.call_out(*args, &block)
      return EventMachine::Timer.new(args[0]) do
        begin
          if block
            block.call
          else
            args[1].send(args[2], *args[3..-1])
          end
        rescue => exception
          puts exception
          puts exception.backtrace
        end
      end
    end

    def self.tell_object(ob, msg)
      ob.catch_tell(msg) if ob.respond_to? :catch_tell
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
      @@objects.values.map{ |k| k.__getobj__ }
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
