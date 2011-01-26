require 'race'

class Human < Race
  def initialize
    @name = self.class.name
  end
end
