class Project < ActiveRecord::Base
  has_many :project_participations, :dependent => :destroy
  has_many :users, :through => :project_participations, :autosave => true
  has_many :suggestions, :dependent => :destroy

  def invite_user(email)
    return false if email.blank?
    existing = User.find_by_email(email)
    if existing
      users << existing
    end
    existing
  end
end
