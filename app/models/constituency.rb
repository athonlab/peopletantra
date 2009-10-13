class Constituency < ActiveRecord::Base
  belongs_to :state
  has_many :candidates

  def member
    
  end

end
