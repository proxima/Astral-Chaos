require './driver/std/efun'
require 'weakref'

class MudObject
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
