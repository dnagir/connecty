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
      do_create(true).should redirect_to inline_project_path(project)
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



  describe 'voting' do
    let(:project) { Factory(:project) }
    subject { Factory(:suggestion, :project => project) }

    def vote(value, more = {})
      post(:vote, more.merge(:project_id => subject.project.id, :suggestion_id => subject.id, :value => value))
    end

    it 'should redirect to project if not inline' do
      vote(1).should redirect_to project_url(project)
    end

    it 'should redirect to inline if inline' do
      vote(-1, :inline => 'true').should redirect_to inline_project_url(project)
    end

    it 'should vote on suggestion' do
      expect {
        vote(1)
      }.to change { subject.reload.votes }.by(1)
    end

  end


  context 'with user' do
    let(:me) { Factory(:user) }
    let(:project) { Factory(:project, :users => [me]) }
    subject { Factory(:suggestion, :project => project) }
    before do
      sign_in me
    end

    describe 'editing' do
      def edit
        get(:edit, :project_id=>project.id, :id=>subject.id)
      end

      it 'should show form' do
        edit.should have_selector('form') do |f|
          f.should have_selector("input[name='suggestion[content]']")
        end
      end

    end



    describe 'updating' do
      def update(attrs={})
        post(:update, :project_id=>project.id, :id=>subject.id, :suggestion=>Factory.attributes_for(:suggestion, attrs))
        assigns(:suggestion)
      end
      
      it 'should ask to log-in' do
        sign_out :user
        update
        response.should redirect_to new_user_session_url
      end

      context 'by a stranger' do
        let(:me) { Factory(:user) }
        it 'should not allow' do
          pending
          update
          response.should redirect_to new_user_session_url
        end
      end
      
      it 'should redirect to project' do
        update
        response.should redirect_to project_url(project)
      end

      it 'should update attributes' do
        update(:status=>:done).status.should == :done
      end
    end

  end


end
