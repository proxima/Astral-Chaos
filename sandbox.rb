require 'shikashi'

module Sandbox
  def self.init
    @@sandbox ||= Shikashi::Sandbox.new
    @@privs   ||= Shikashi::Privileges.new

    @@privs.allow_class_definitions
    @@privs.allow_const_read "String", "Hash", "Array"
    @@privs.allow_singleton_methods
     
    @@privs.allow_method(:+)
    @@privs.allow_method(:-)
    @@privs.allow_method(:attr_accessor)
    @@privs.allow_method(:new)
    @@privs.allow_method(:require)

    @@privs.instances_of(String).allow_all
    @@privs.instances_of(Array).allow_all
    @@privs.instances_of(Hash).allow_all       
  end

  def self.execute(code)
    @@sandbox.run(code, @@privs, :timeout => 0.5)
  end
end
