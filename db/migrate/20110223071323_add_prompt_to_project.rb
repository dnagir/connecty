class AddPromptToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :prompt, :string, :default => 'your feedback'
    add_column :projects, :show_name, :boolean, :default => true
  end

  def self.down
    remove_column :projects, :show_name
    remove_column :projects, :prompt
  end
end
