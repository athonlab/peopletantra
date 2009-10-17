class Party < ActiveRecord::Base
  def to_s
    code
  end
end
