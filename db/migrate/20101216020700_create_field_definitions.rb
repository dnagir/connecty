class CreateFieldDefinitions < ActiveRecord::Migration
  def self.up
    create_table :field_definitions do |t|
      t.string :name
      t.text :value
      t.references :project
    end
  end

  def self.down
    drop_table :field_definitions
  end
end
