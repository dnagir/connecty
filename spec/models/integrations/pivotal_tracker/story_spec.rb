require 'spec_helper'

describe Integrations::PivotalTracker::Story do

  def valid_story(args={})
    Integrations::PivotalTracker::Story.new({
      :project_id=>1, 
      :name=>'abcd', 
      :description=>'a description', 
      :email=>'user@example.com', 
      :password=>'secret pwd'}.merge(args))
  end

  subject do
    story = valid_story
    story.stub(:do_get_project!).and_return(double('project'))
    story.stub(:do_create!).and_return(true)
    story
  end

  describe 'pushing to PT' do
    describe 'validation' do
      it { should ensure_length_of(:name).is_at_least(3).is_at_most(50) }
      it { should ensure_length_of(:description).is_at_least(3).is_at_most(120) }
      it { should validate_numericality_of(:project_id) }

      describe 'retrieveing project' do
        it 'should not validate if project is not found' do
          subject.stub(:do_get_project!).and_return(nil)
          subject.should_not be_valid
          subject.should have(1).error_on(:project_id)
        end
        it 'should validate if project is found' do
          subject.should be_valid
          subject.should have(:no).errors_on(:project_id)
        end
      end
    end

  end

end
