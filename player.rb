require 'digest/sha1'
require 'yaml'

class Player

  attr_accessor :name, :hashed_password, :salt
  attr_accessor :race

  def initialize(name)
    @name = name
  end

  def password=(pass)
    @salt = Player.random_string(10) if !@salt
    @hashed_password = Player.encrypt(pass, @salt)
  end

  def check_password?(pass)
    return (@hashed_password == Digest::SHA1.hexdigest(pass+@salt))    
  end

  def self.pfile_exists?(name)
    filename = "./data/players/#{name.downcase}.dat"
    return File.exists?(filename)
  end

  def save
    f = File.new(Player.get_filename(@name), "w")
    f.write(YAML::dump(self))
    f.close
  end
 
  def self.load(name)
    f = File.new(Player.get_filename(name), "r")
    data = f.read
    obj = YAML::load data
    f.close
    return obj
  end
 
  def self.get_filename(name)
    "./data/players/#{name.downcase}.dat"
  end

protected

  def self.encrypt(pass,salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
