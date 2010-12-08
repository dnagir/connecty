class Integrations::PivotalTracker::Story
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  def persisted?; false; end

  validates_presence_of :project_id, :name
  validates_numericality_of :project_id, :greater_than => 0
  validates_length_of :name, :within => 3..50
  validates_length_of :description, :within => 3..120
  validate do
    errors.add(:project_id, "enter an id of project that you have access to and/or check the email/password") if errors.empty? and not do_get_project!
  end


  attr_accessor :project_id, :name, :description, :email, :password

  def initialize(args={})
    args ||= {}
    %w{project_id name description email password}.each do |what|
      self.instance_variable_set("@#{what}", args[what])
    end
  end

  def create(user)
    return false if not valid?
    do_create!    
  end

  protected
    def do_get_project!
      @project ||= begin
        PivotalTracker::Client.token(self.email, self.password) unless email.blank?
        PivotalTracker::Project.find(self.project_id)        
      rescue
        Rails.logger.error($!)
        return nil
        #TODO do useful stuff and logging here
      end
    end

    def do_create!
      story = do_get_project!.stories.create(:name => self.name, :description => self.description, :story_type => 'feature')
    ensure
      PivotalTracker::Client.token = nil
    end

end
