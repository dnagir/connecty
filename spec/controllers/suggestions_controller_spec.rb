require 'spec_helper'

describe SuggestionsController do
  render_views

  let(:me) { Factory(:user) }
  let(:project) { Factory(:project, :users=>[me]) }
  let(:suggestion) { Factory(:suggestion, :project => project) }

  describe '#create' do
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

    it 'should mark suggestion as voted by me' do
      pending "haven't figured out how to get/set cookie"
      vote(1)
      cookies[:voted].should include suggestion.id.to_s
    end

    it 'should not vote twice' do
      pending "haven't figured out how to get/set cookie"
      cookies[:voted] = suggestion.id.to_s
      expect { vote(1) }.to_not change { suggestion.votes }
    end

    it 'should explain why I cannot vote doing it twice' do
      pending "haven't figured out how to get/set cookie"
      cookies[:voted] = suggestion.id.to_s
      vote(1)
      flash[:notice].should match /already voted/
    end
  end


  context 'with user' do
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
        response.should require_authentication
      end

      context 'by another user' do
        before do
          sign_in Factory(:user)
        end
        it 'should not allow' do
          update
          response.should deny_access
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

  describe 'PivotalTracker' do    
    def valid_story
      {'password'=>'123456', 'name'=>suggestion.content_brief, 'description'=>suggestion.content, 'email'=>me.email,'project_id'=>999}
    end
    def do_get
      get(:pivotal_story, :project_id=>project.id, :suggestion_id=>suggestion.id)
    end
    def do_create
      post(:pivotal_story, :project_id=>project.id, :suggestion_id=>suggestion.id, :integrations_pivotal_tracker_story => valid_story) 
    end
    let(:story) do
      Integrations::PivotalTracker::Story.new(valid_story).tap do |s|
        s.stub(:valid?).and_return(true)
        s.stub(:do_create!).and_return(true)
        Integrations::PivotalTracker::Story.stub(:new).and_return(s)
      end
    end

    context 'with invalid user' do
      before { sign_in Factory.create(:user) }
      it "should prohibit to see details"     do do_get.should deny_access    end
      it "should prohibit to push the story"  do do_create.should deny_access end
    end

    context 'with a valid user' do
      before { sign_in me }
      it 'should push the story' do
        story.should_receive(:do_create!)
        do_create
      end
    end
  end


  context 'with user' do
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
        response.should require_authentication
      end

      context 'by another user' do
        before do
          sign_in Factory(:user)
        end
        it 'should not allow' do
          update
          response.should deny_access
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

  describe 'PivotalTracker' do    
    def valid_story
      {'password'=>'123456', 'name'=>suggestion.content_brief, 'description'=>suggestion.content, 'email'=>me.email,'project_id'=>999}
    end
    def do_get
      get(:pivotal_story, :project_id=>project.id, :suggestion_id=>suggestion.id)
    end
    def do_create
      post(:pivotal_story, :project_id=>project.id, :suggestion_id=>suggestion.id, :integrations_pivotal_tracker_story => valid_story) 
    end
    before do
      story = Integrations::PivotalTracker::Story.new(valid_story)
      story.stub(:valid?).and_return(true)
      story.stub(:do_create!).and_return(true)
      Integrations::PivotalTracker::Story.stub(:new).and_return(story)
    end

    it 'should require user' do
      sign_out :user
      do_get.should require_authentication
    end
    it 'should require authorisation' do
      sign_in Factory(:user)
      do_get.should deny_access
    end

    it 'should render form' do
      sign_in me
      do_get.should have_selector('form')
    end

    it 'should prefil story' do
      sign_in me
      do_get
      story = assigns(:story)
      story.name.should == suggestion.content_brief
      story.description.should == suggestion.content
      story.email.should == me.email
    end

    it 'should redirect to edit suggestion' do
      sign_in me
      do_create.should redirect_to edit_project_suggestion_url(project, suggestion)
    end
  end


  describe '#destroy' do
    def delete
      post :destroy, :id => suggestion.id, :project_id => project.id
    end

    it 'should require authorisation' do
      sign_in Factory(:user)
      delete.should deny_access
    end

    context 'by authorised user' do
      before do
        sign_in me
      end

      it 'should redirect to project' do
        delete.should redirect_to project_url(project)
      end      
    end

  end
end
