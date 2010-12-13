require 'spec_helper'

describe Suggestion do
  describe 'associations' do
    it { should belong_to(:project) }
  end

  its(:votes) { should == 1 }
  it { should validate_presence_of(:project_id) }
  it { should ensure_length_of(:content).is_at_least(3).is_at_most(120) }
  its(:status) { should == :open }

  describe 'voting' do
    let(:project) { Factory(:project) }
    subject { Factory(:suggestion, :project => project, :votes=>0) }
    def vote(value)
      subject.vote(value).should be_true
      subject.reload.votes
    end

    it 'should upvote' do
      vote(1).should == 1
    end

    it 'should downvote' do
      vote(-1).should == -1
    end

    it 'should not change vote with 0' do
      vote(0).should == 0
    end


    it 'should upvote with 1 point only' do
      vote(100).should == 1
    end

    it 'should downvote with 1 point only' do
      vote(-100).should == -1
    end
  end
end
