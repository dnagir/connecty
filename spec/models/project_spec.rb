require 'spec_helper'

describe Project do
  describe 'associations' do
    it { should have_many(:users).through(:project_participations) }
    it { should have_many(:project_participations).dependent(:destroy) }
    it { should have_many(:suggestions).dependent(:destroy) }
  end
  
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
end
