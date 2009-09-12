class Revision < ActiveRecord::Base
  has_many :candidate_revisions
  has_many :candidates, :through => :candidate_revisions
  def self.default_loksabha
    self.find(:first, :conditions => {:house => 'loksabha'}, :order => :id )
  end

  def self.default_rajyasabha
    self.find(:first, :conditions => {:house => 'rajyasabha'}, :order => :id )
  end

end
