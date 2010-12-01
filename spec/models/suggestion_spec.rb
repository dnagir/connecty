require 'spec_helper'

describe Suggestion do
  describe 'associations' do
    it { should belong_to(:project) }
  end

  it { subject.votes.should == 0 }
  it { should validate_presence_of(:project_id) }
  it { should ensure_length_of(:content).is_at_least(3).is_at_most(120) }
  
end
