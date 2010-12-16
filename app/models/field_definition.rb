class FieldDefinition < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id
  validates_length_of :name, :within => 3..50
  validates_length_of :value, :within => 1..1024
  validates_uniqueness_of :name, :scope => :project_id, :case_sensitive => false
end
