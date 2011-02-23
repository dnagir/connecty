require 'spec_helper'

describe ProjectsController do
  render_views

  let(:me) { Factory(:user) }
  let(:project) { Factory.create(:project, :users => [me]) }

  describe '#new' do
    def act
      get :new
    end

    it_behaves_like 'protected action', :with => :no_resource

    it 'should render form' do
      sign_in me
      act.should have_selector("form[action='#{projects_path}']")
    end
  end


  describe '#create' do
    def act
      post :create, :project => Factory.attributes_for(:project)
    end

    it_behaves_like 'protected action', :with => :no_resource

    context 'as a user' do
      before { sign_in me }
      it 'should create a project' do
        expect { act }.to change { me.projects(true).count }.by(1)
      end

      it 'should redirect to the install instructions' do
        act.should redirect_to install_project_url(assigns[:project])
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

    it_behaves_like 'protected action'

    context 'as logged-in user' do
      before { sign_in me }

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

    it 'should not show project name when disabled' do
      project.show_name = false
      project.save!
      result.should_not contain project.name
    end

    it 'should show prompt' do
      project.prompt = 'just say something'
      project.save!
      result.should contain 'just say something'
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

    it_behaves_like 'protected action'

    context 'as a user' do
      before { sign_in me }

      it { result.should be_successful }

      it 'should have installation code' do
        result.should have_selector('pre')
      end
    end

  end




  describe '#invite' do

    context "#get" do
      def result
        get(:invite, :id => project.id)
      end

      it_behaves_like 'protected action'

      it 'should render form with email' do
        sign_in me
        result.should have_selector('form') do |f|
          f.should have_selector('input[name="user[email]"]')
          f.should have_selector('input[type="submit"]')
        end
      end
    end

    context 'as logged-in user' do
      def act
        email = Factory(:user).email
        post :invite, :id => project.id, :user => { :email => email}
      end

      it_behaves_like 'protected action'

      it 'should redirect to project after adding' do
        sign_in me
        act.should redirect_to project_url(project)
      end

    end
  end




  describe '#edit' do    
    def result
      get :edit, :id=>project.id
    end

    it_behaves_like 'protected action'

    context 'by authorised user' do
      before { sign_in me }
      it 'should show project details' do
        result.should contain(project.name)
      end
      it 'should render form' do
        result.should have_selector('form')
      end
    end
  end



  describe '#update' do
    def update(args={:name=>'new name'})
      post :update, :id=>project.id, :project=>args
    end

    it_behaves_like 'protected action'

    context 'by authorised user' do
      before { sign_in me }
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
