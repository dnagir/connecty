require 'spec_helper'

describe ProjectsController do
  render_views

  let(:me) { Factory(:user) }

  describe '#new' do
    def result
      get :new
    end

    context 'as anonim' do
      before do
        sign_out :user
      end

      it 'should ask to log-in' do
        result.should redirect_to new_user_session_url
      end
    end

    context 'as a user' do
      before do
        sign_in me
      end

      it 'should render form' do
        result.should have_selector("form[action='#{projects_path}']")
      end
    end

  end


  describe '#create' do
    def result
      post :create, :project => Factory.attributes_for(:project)
    end

    context 'as anonim' do
      before do
        sign_out :user
      end

      it 'should ask to log-in' do
        result.should redirect_to new_user_session_url
      end

    end

    context 'as a user' do
      before do
        sign_in me
      end

      it 'should create a project' do
        expect {
          result();
        }.to change { Project.count }.by(1)
      end

      it 'should add project to myself' do
        result()
        me.reload.should have(1).project
      end

      it 'should redirect to the install instructions' do
        result.should redirect_to install_project_url(assigns[:project])
      end

    end
  end



  describe '#show' do
    let(:project) do
      Factory.create(:project).tap do |p|
        3.times { Factory.create(:suggestion, :project => p) }
      end
    end
    def result(more = {})
      get :show, { :id => project.id }.merge(more)
    end

    it 'should show project name' do
      result.should contain project.name
    end

    it 'should list suggestions' do
      result.should have_selector('div.suggestion', :count => 3)
    end
    
    it 'should have suggestion form' do
      result.should have_selector("form[action='#{project_suggestions_path(project.id)}']")
    end

    it 'should use default template' do
      result.should render_template(:application)
    end

    context 'inline' do
      it { result(:inline=>'true').should render_template(:inline) }
    end

  end


  describe '#install' do
    let(:project) { Factory.create(:project) }
    def result
      get :install, :id => project.id
    end

    context 'as anonim' do
      before do
        sign_out :user
      end

      it 'should ask to log-in' do
        result.should redirect_to new_user_session_url
      end

    end

    context 'as a user' do
      before do
        sign_in me
      end

      it { result.should be_successful }
      
      it 'should have installation code' do
        result.should have_selector('pre')
      end

    end

  end
end
