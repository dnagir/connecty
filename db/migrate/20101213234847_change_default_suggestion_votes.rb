class ChangeDefaultSuggestionVotes < ActiveRecord::Migration
  def self.up
     change_column_default :suggestions, :votes, 1
  end

  def self.down
     change_column_default :suggestions, :votes, 0
  end
end
