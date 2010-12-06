class AddStatusToSuggestion < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :status, :string, :default => 'open'
  end

  def self.down
    remove_column :suggestions, :status
  end
end
