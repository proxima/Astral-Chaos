class Race
  attr_accessor :name

  def initialize(name)
    @name = self.class.name
  end
end

