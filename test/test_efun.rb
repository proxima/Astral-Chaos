require 'test/unit'
require './driver/std/efun'
require './driver/std/mud_object'

class C < MudObject
end

class TestEfun < Test::Unit::TestCase
  def test_base_name
    c = C.new
    assert_equal(Efun::base_name(c), c.class.name)
  end

  def test_object_name
    c = C.new
    assert_match(/.+#\d+\z/, Efun::object_name(c))
  end

  def test_find_object
    c = C.new
    assert(Efun::find_object(Efun::object_name(c)).equal?(c))
    assert_equal(c, Efun::find_object(Efun::object_name(c)))
    assert_nil(Efun::find_object('asdf#12345'))
  end
end
