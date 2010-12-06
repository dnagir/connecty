require 'spec_helper'
require "cancan/matchers"

describe Ability do
  subject { Ability.new(current_user) }
  
  describe 'managing suggestions' do
    let(:me) { Factory(:user) }
    let(:current_user) { me }
    let(:my_project) { Factory(:project, :users => [me]) }
    let(:my_suggestion) { Factory(:suggestion, :project => my_project) }

    
    it 'should allow owner to manage his suggestions' do
      subject.should be_able_to(:manage, my_suggestion)
    end

    it 'should not allow to manage not owning suggestions' do
      subject.should_not be_able_to(:manage, Factory(:suggestion))
    end

  end

end
