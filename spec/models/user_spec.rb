require 'spec_helper'

describe User do
  describe 'relations' do
    it { should have_many(:projects).through(:project_participations) }
    it { should have_many(:project_participations).dependent(:destroy) }
  end
end
