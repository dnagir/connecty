class Suggestion < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_length_of :content, :within => 3..50
end
