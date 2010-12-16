require 'spec_helper'

describe FieldDefinitionsController do
  render_views
  let(:me) { Factory.create(:user) }
  let(:project) { Factory.create(:project, :users=>[me]) }

  describe '#new' do
    def act
      get(:new, :project_id=>project.id)
    end
    #it_behaves_like 'protected action'
  end

end

