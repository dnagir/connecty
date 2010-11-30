class Project < ActiveRecord::Base
  has_many :project_participations, :dependent => :destroy
  has_many :users, :through => :project_participations
  has_many :suggestions, :dependent => :destroy
end
