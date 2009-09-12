class StateForRajyasabhaCandidates < ActiveRecord::Migration
  def self.up
    add_column :candidates, :state_id, :integer
  end

  def self.down
    remove_column :candidates, :state_id
  end
end
