require 'spec_helper'
require "cancan/matchers"

describe Ability do
  subject { Ability.new(current_user) }
  let(:me) { Factory(:user) }
  let(:current_user) { me }
  let(:my_project) { Factory(:project, :users => [me]) }

  describe 'managing projects' do
    it 'should allow to create' do
      subject.should be_able_to(:new, Project)
      subject.should be_able_to(:create, Project)
    end
    it 'should allow to see my project' do
      subject.should be_able_to(:show, my_project)
      subject.should be_able_to(:install, my_project)
      subject.should be_able_to(:invite, my_project)
    end
    it 'should not see non-mine project' do
      other = Factory(:project)
      subject.should_not be_able_to(:show, other)
      subject.should_not be_able_to(:install, other)
      subject.should_not be_able_to(:invite, other)
    end
  end  
  
  describe 'managing suggestions' do
    let(:my_suggestion) { Factory(:suggestion, :project => my_project) }

    
    it 'should allow owner to manage his suggestions' do
      subject.should be_able_to(:manage, my_suggestion)
    end

    it 'should not allow to manage not owning suggestions' do
      subject.should_not be_able_to(:manage, Factory(:suggestion))
    end

  end

end
