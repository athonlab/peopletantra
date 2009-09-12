class FieldsFromIndiaGov < ActiveRecord::Migration
  def self.up
    add_column :candidates, :display_name, :string
    add_column :candidates, :fathers_name, :string
    add_column :candidates, :mothers_name, :string
    add_column :candidates, :date_of_birth, :date
    add_column :candidates, :birth_place, :string
    add_column :candidates, :married, :boolean
    add_column :candidates, :married_on, :date
    add_column :candidates, :spouse_name, :string
    add_column :candidates, :no_of_children, :integer
    add_column :candidates, :no_of_sons, :integer
    add_column :candidates, :no_of_daughters, :integer
    add_column :candidates, :permanent_address, :string
    add_column :candidates, :present_address, :string
    add_column :candidates, :qualification, :string
    add_column :candidates, :studied_at, :string
    add_column :candidates, :profession, :string
    add_column :candidates, :positions_held, :text
    add_column :candidates, :activities_achievements_interests, :text
    add_column :candidates, :sports_n_recreation, :text
    add_column :candidates, :hobbies, :text
    add_column :candidates, :travelled, :text
    add_column :candidates, :other_info, :text
    add_column :candidates, :party_name, :string
  end

  def self.down

  end
end
