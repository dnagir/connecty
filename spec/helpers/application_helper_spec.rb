require 'spec_helper'

describe ApplicationHelper do

  describe '#connecty_install_script' do
    let(:project) { Factory(:project) }

    it 'should include inline link' do
      helper.connecty_install_script(project).should include(inline_project_url(project))
    end
  end

  describe '#link_to_toggle' do
    def link
      link_to_toggle :it, true, [:project_path, 111], :on=>'hide', :off=>'show'
    end
    it 'should add query string value' do
      link.should =~ /it=false/
    end
    it 'should produce path' do
      link.should include project_path(111)
    end
    it 'should has the link text' do
      link.should include 'hide'
    end
  end
end
