require './driver/player.rb'
require 'securerandom'
require 'test/unit'

class TestPlayer < Test::Unit::TestCase
  def self.startup
    @@player = Player.new(SecureRandom.uuid)
  end

  def test_password
    password = SecureRandom.uuid
    @@player.password = password
    assert(@@player.check_password?(password))
    assert(!@@player.check_password?('test'));
  end

  def test_save_load
    @@player.save
    p = Player.load(@@player.name)
    @@player.instance_variables.each { |var| assert_equal(p.instance_variable_get(var), @@player.instance_variable_get(var)) }
  end

  def test_save_rm
    @@player.save
    assert(Player.pfile_exists?(@@player.name))
    Player.rm!(@@player.name)
    assert(!Player.pfile_exists?(@@player.name))
  end
end
