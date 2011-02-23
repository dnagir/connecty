require 'spec_helper'

describe Project do
  describe 'associations' do
    it { should have_many(:users).through(:project_participations) }
    it { should have_many(:project_participations).dependent(:destroy) }
    it { should have_many(:suggestions).dependent(:destroy) }
    it { should have_many(:field_definitions).dependent(:destroy) }
  end

  its(:show_name) { should == true }
  its(:prompt) { should == 'your feedback' }
  
  describe 'basic validation' do
    it { should ensure_length_of(:name).is_at_least(3).is_at_most(25) }
  end

  describe 'invitation' do
    subject { Factory(:project) }
    let(:user1) { Factory.create(:user) }

    it 'should return invited user' do
      subject.invite_user(user1.email).should == user1
    end

    it 'should add user to project' do
      subject.invite_user(user1.email)
      subject.users(true).should include(user1)
    end
  end

  describe 'suggestions' do
    let(:project) { Factory.create(:project) }
    def with_status(status)
      Factory.create(:suggestion, :status => status, :project => project)
      project.suggestions.published
    end

    def suggestion
      project.suggestions.first
    end

    context '#published' do      
      it 'should appear when open' do
        with_status(:open).should include(suggestion)
      end
      it 'should appear when in_progress' do
        with_status(:in_progress).should include(suggestion)
      end
      it 'should not appear when done' do
        with_status(:done).should_not include(suggestion)
      end
    end
  end
end
