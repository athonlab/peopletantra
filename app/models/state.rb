class State < ActiveRecord::Base
  has_many :constituencies

  def to_s
    name
  end
end
