require 'test/unit'
require './driver/bootstrap/efun'

class C
end

module M
end

class TestEfun < Test::Unit::TestCase
  def test_base_name
    assert_equal(base_name(self), self.class.name)
  end

  def test_object_name
    assert_match(/.+#\d+\z/, object_name(self))
  end

  def test_find_object
    assert_equal(self, find_object(object_name(self)))
    assert_nil(find_object('asdf#12345'))
  end

  def test_efuns_accessible
    Efun.private_instance_methods.each { |m| assert_include(C.private_methods, m) }
    Efun.private_instance_methods.each { |m| assert_include(C.private_instance_methods, m) }
    Efun.private_instance_methods.each { |m| assert_include(M.private_methods, m) }
  end
end
