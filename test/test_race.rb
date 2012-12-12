require './human.rb'
require './race.rb'
require 'test/unit'

class TestRaceInheritance < Test::Unit::TestCase
  def test_human_inheritance
    h = Human.new
    assert_equal h.name, :Human
  end
end
