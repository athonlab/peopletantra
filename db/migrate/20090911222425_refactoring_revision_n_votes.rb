class RefactoringRevisionNVotes < ActiveRecord::Migration
  def self.up
    create_table :elections do |t|
      t.string :name
      t.timestamps
    end
    create_table :election_candidates do |t|
      t.integer :election_id
      t.integer :candidate_id
      t.integer :postal_votes
      t.integer :evm_votes
      t.integer :total_votes
      t.timestamps
    end
    add_column :revisions, :house, :string
    remove_column :candidate_revisions, :postal_votes
    remove_column :candidate_revisions, :evm_votes
    remove_column :candidate_revisions, :total_votes
  end

  def self.down
    drop_table :elections
    drop_table :election_candidates
    remove_column :revisions, :house
    add_column :candidate_revisions, :postal_votes, :integer
    add_column :candidate_revisions, :evm_votes, :integer
    add_column :candidate_revisions, :total_votes, :integer
  end
end
