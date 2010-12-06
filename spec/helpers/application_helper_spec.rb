require 'spec_helper'

describe ApplicationHelper do

  describe '#connecty_install_script' do
    let(:project) { Factory(:project) }

    it 'should include inline link' do
      helper.connecty_install_script(project).should include(inline_project_url(project))
    end
  end

end
