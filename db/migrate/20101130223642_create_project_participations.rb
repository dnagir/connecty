class CreateProjectParticipations < ActiveRecord::Migration
  def self.up
    create_table :project_participations, :id => false do |t|
      t.references :user
      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :project_participations
  end
end
