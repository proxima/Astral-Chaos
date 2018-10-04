require './lib/races/human.rb'
require './lib/std/race.rb'
require 'test/unit'

class TestRaceInheritance < Test::Unit::TestCase
  def test_human_inheritance
    assert Human < Race
  end

  def test_human_name_set_properly
    h = Human.new
    assert_equal h.name, :Human
  end

  def test_new_human_has_correct_number_of_stats
    h = Human.new
    assert_equal h.stats.size, Race::ALL_STATS.size
  end

  def test_new_human_has_correct_base_stats
    h = Human.new
    h.stats.each_pair {|k,v| assert_equal v, Race::BASE_STAT  }
  end
end

