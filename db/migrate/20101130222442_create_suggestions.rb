class CreateSuggestions < ActiveRecord::Migration
  def self.up
    create_table :suggestions do |t|
      t.string :content
      t.integer :votes, :default => 0

      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :suggestions
  end
end
