require 'spec_helper'

describe SuggestionsController do
  render_views

  describe '#create' do
    let(:project) { Factory(:project) }
    def do_create(inline=false, attrs={})
      post :create, :project_id => project.id, :inline => inline.to_s, :suggestion => Factory.attributes_for(:suggestion, attrs)
    end

    it 'should create suggestion' do
      expect {
        do_create
      }.to change { project.reload.suggestions.count }.by(1)
    end

    it 'should redirect to the project' do
      do_create.should redirect_to project_path(project)
    end
    it 'should redirect preserving inline option' do
      do_create(true).should redirect_to project_path(project, :inline => 'true')
    end


    context 'with invalid suggestion' do
      def do_invalid(inline=false)
        do_create inline, :content => nil
      end

      it { do_invalid.should render_template('new') }

      it 'should not create suggestion' do
        expect { do_invalid }.to change {project.suggestions.count}.by(0)
      end
      
      it 'should render page preserving inline option' do
        do_invalid(true).should have_selector("input[name='inline']")
      end

      it 'should render page inline' do
        do_invalid(true).should render_template(:inline)
      end

    end

  end

end
