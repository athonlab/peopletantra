class CreateCandidateRevisions < ActiveRecord::Migration
  def self.up
    create_table :candidate_revisions do |t|
      t.integer :revision_id
      t.integer :candidate_id
      t.integer :postal_votes
      t.integer :evm_votes
      t.integer :total_votes

      t.timestamps
    end
  end

  def self.down
    drop_table :candidate_revisions
  end
end
