class Suggestion < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_length_of :content, :within => 3..120

  def vote(value)
    return true if not value or value == 0
    self.votes += value > 0 ? 1 : -1
    self.save
  end
end
