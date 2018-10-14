require 'test/unit'
require 'weakref'

require './driver/std/base'

class C < Mud::Object
end

class TestEfun < Test::Unit::TestCase
  def test_base_name
    c = C.new
    assert_equal(Mud::Efun::base_name(c), c.class.name)
  end

  def test_object_name
    c = C.new
    assert_match(/.+#\d+\z/, Mud::Efun::object_name(c))
  end

  def test_find_object
    c = C.new
    assert(Mud::Efun::find_object(Mud::Efun::object_name(c)).equal?(c))
    assert_equal(c, Mud::Efun::find_object(Mud::Efun::object_name(c)))
    assert_nil(Mud::Efun::find_object('asdf#12345'))
  end

  def test_keys_values
    c = C.new

    assert(Mud::Object.values.include?(c))
    assert(Mud::Object.keys.include?(Mud::Efun::object_name(c)))
  end

  def test_not_returning_weakrefs
    c = C.new

    assert(Mud::Object.values.include?(c))

    Mud::Object.values.each do |ob|
      assert(!ob.is_a?(WeakRef))
    end
  end
end
