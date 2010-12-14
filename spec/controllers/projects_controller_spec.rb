require 'spec_helper'

describe ProjectsController do
  render_views

  let(:me) { Factory(:user) }
  let(:project) { Factory.create(:project, :users => [me]) }

  describe '#new' do
    def result
      get :new
    end

    context 'as anonim' do
      before do
        sign_out :user
      end

      it 'should ask to log-in' do
        result.should require_authentication
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
        result.should require_authentication
      end

    end

    context 'as a user' do
      before do
        sign_in me
      end

      it 'should create a project' do
        expect {
          result();
        }.to change { me.projects(true).count }.by(1)
      end

      it 'should redirect to the install instructions' do
        result.should redirect_to install_project_url(assigns[:project])
      end

    end    
  end




  describe '#show' do
    let(:project) do
      Factory.create(:project, :users => [me]).tap do |p|
        3.times { |n| Factory.create(:suggestion, :votes => n, :project => p) }
      end
    end
    def result(more = {})
      get :show, { :id => project.id }.merge(more)
    end

    it 'should ask to log-in' do
      sign_out :user
      result.should require_authentication
    end

    context 'as logged-in user' do
      before do
        sign_in me
      end

      it 'should not see other projects' do
        sign_in Factory(:user)
        result.should deny_access
      end

      it 'should show project name' do
        result.should contain project.name
      end

      it 'should list suggestions' do
        result.should have_selector('div.suggestion', :count => 3)
      end
      
      it 'should order suggestions' do
        result.should have_selector('div.suggestion .voting .current') do |v|
          v.map(&:text).map(&:to_i).should == [2,1,0]
        end
      end

      it 'should use default template' do
        result.should render_template(:application)
      end
    end

  end



  describe '#inline' do
    let(:project) do
      Factory.create(:project).tap do |p|
        3.times { |n| Factory.create(:suggestion, :votes => n, :project => p) }
      end
    end
    def result(more = {})
      get :inline, { :id => project.id }.merge(more)
    end

    it 'should show project name' do
      result.should contain project.name
    end

    it 'should list suggestions' do
      result.should have_selector('div.suggestion', :count => 3)
    end

    it 'should order suggestions' do
      result.should have_selector('div.suggestion .voting .current') do |v|
        v.map(&:text).map(&:to_i).should == [2,1,0]
      end
    end

    it 'should not show finished suggestions' do
      done = Factory(:suggestion, :status => :done, :project => project)
      result.should_not contain(done.content)
    end

    it 'suggestions votes should be inline' do
      result.should have_selector('div.suggestion .up a, div.suggestion .dn a') do |s|
        s.attribute('href').should contain('inline')
      end
    end
    
    it 'should have suggestion form' do
      result.should have_selector("form[action='#{project_suggestions_path(project.id)}']")
    end

    it 'should use inline template' do
      result.should render_template(:inline)
    end

  end


  describe '#install' do
    def result
      get :install, :id => project.id
    end

    context 'as anonim' do
      before do
        sign_out :user
      end

      it 'should ask to log-in' do
        result.should require_authentication
      end

    end

    context 'as a user' do
      before do
        sign_in me
      end

      it { result.should be_successful }

      it 'should not see other projects' do
        sign_in Factory(:user)
        result.should deny_access
      end
      
      it 'should have installation code' do
        result.should have_selector('pre')
      end

    end

  end




  describe '#invite' do
    def result
      get(:invite, :id => project.id)
    end
    def do_invite
      email = Factory(:user).email
      post :invite, :id => project.id, :user => { :email => email}
    end

    it 'should ask to log-in' do
      result.should require_authentication
    end

    context 'as logged-in user' do
      before do
        sign_in me
      end

      it 'should render form with emails' do
        result.should have_selector('form') do |f|
          f.should have_selector('input[name="user[email]"]')
          f.should have_selector('input[type="submit"]')
        end
      end

      it 'should redirect to project after adding' do
        do_invite.should redirect_to project_url(project)
      end

    end
  end




  describe '#edit' do    
    def edit
      get :edit, :id=>project.id
    end
    it 'should deny access to other users' do
      sign_in Factory(:user)
      edit.should deny_access
    end

    context 'by authorised user' do
      before do
        sign_in me
      end
      it 'should show project details' do
        edit.should contain(project.name)
      end
      it 'should render form' do
        edit.should have_selector('form')
      end
    end
  end



  describe '#update' do
    def update(args={:name=>'new name'})
      post :update, :id=>project.id, :project=>args
    end
    it 'should deny access to other users' do
      sign_in Factory(:user)
      update.should deny_access
    end

    context 'by authorised user' do
      before do
        sign_in me
      end
      it 'should redirect to #show' do
        update.should redirect_to project_url(project)
      end
      it 'should update project' do
        update
        project.reload.name.should == 'new name'
      end
      it 'should render form with errors' do
        update(:name=>'').should render_template :edit
      end
    end
  end

end
