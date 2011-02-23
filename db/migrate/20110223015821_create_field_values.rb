class CreateFieldValues < ActiveRecord::Migration
  def self.up
    create_table :field_values do |t|
      t.string :name
      t.text :value
      t.references :suggestion

      t.timestamps
    end
  end

  def self.down
    drop_table :field_values
  end
end
