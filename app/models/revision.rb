class Revision < ActiveRecord::Base
  
  def self.default
    self.last
  end

end
