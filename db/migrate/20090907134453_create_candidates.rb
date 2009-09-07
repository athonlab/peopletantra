class CreateCandidates < ActiveRecord::Migration
  def self.up
    create_table :candidates do |t|
      t.string :name
      t.string :sex
      t.string :address_line_1
      t.string :address_line_2
      t.string :city_town_village
      t.integer :age
      t.string :category
      t.integer :constituency_id
      t.integer :party_id

      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end
