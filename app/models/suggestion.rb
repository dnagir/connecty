class Suggestion < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_length_of :content, :within => 3..120

  STATUSES = [:open, :in_progress, :done]

  scope :published, where(:status => [:open, :in_progress])
  scope :most_voted, order('votes DESC')

  def self.statuses_readable
    STATUSES.inject({}) {|all, sym| all[status_name_for(sym)] = sym; all }
  end

  def self.status_name_for(it)
    return 'N/A' unless it
    it.to_s.humanize
  end

  def status
    read_attribute(:status).to_sym
  end
  def status=(value)
    value = value.to_sym
    raise "Non accepted value for status: #{value}" unless STATUSES.include?(value)
    write_attribute(:status, value.to_s)
  end

  def status_readable
    Suggestion.status_name_for(status)
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
