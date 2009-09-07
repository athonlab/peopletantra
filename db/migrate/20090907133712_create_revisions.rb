class CreateRevisions < ActiveRecord::Migration
  def self.up
    create_table :revisions do |t|
      t.integer :number

      t.timestamps
    end
  end

  def self.down
    drop_table :revisions
  end
end
