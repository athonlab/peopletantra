class Election < ActiveRecord::Base
  
  def self.default
    self.last
  end

end
