require 'spec_helper'

describe Project do
  describe 'associations' do
    it { should have_many(:users).through(:project_participations) }
    it { should have_many(:project_participations).dependent(:destroy) }
    it { should have_many(:suggestions).dependent(:destroy) }
  end
end
