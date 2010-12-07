class Suggestion < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_length_of :content, :within => 3..120

  STATUSES = [:open, :in_progress, :done]

  def status
    read_attribute(:status).to_sym
  end
  def status=(value)
    value = value.to_sym
    raise "Non accepted value for status: #{value}" unless STATUSES.include?(value)
    write_attribute(:status, value.to_s)
  end


  def vote(value)
    return true if not value or value == 0
    self.votes += value > 0 ? 1 : -1
    self.save
  end

  def content_brief
    (content || '').truncate(20, :separator => ' ')
  end
end
