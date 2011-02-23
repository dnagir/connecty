require 'spec_helper'

describe SuggestionsController do
  render_views

  let(:me) { Factory(:user) }
  let(:project) { Factory(:project, :users=>[me]) }
  let(:suggestion) { Factory(:suggestion, :project => project) }

  describe '#create' do
    def act(inline=false, attrs={})
      post :create, :project_id => project.id, :inline => inline.to_s, :suggestion => Factory.attributes_for(:suggestion, attrs)
    end

    it 'should create suggestion' do
      expect { act }.to change { project.reload.suggestions.count }.by(1)
    end

    it 'should redirect to the project' do
      act.should redirect_to project_path(project)
    end
    it 'should redirect preserving inline option' do
      act(true).should redirect_to inline_project_path(project)
    end


    context 'with invalid suggestion' do
      def act(inline=false)
        post :create, :project_id => project.id, :inline => inline.to_s, :suggestion => Factory.attributes_for(:suggestion, :content=>nil)
      end

      it { act.should render_template('new') }

      it 'should not create suggestion' do
        expect { act }.to change {project.suggestions.count}.by(0)
      end
      
      it 'should render page preserving inline option' do
        act(true).should have_selector("input[name='inline']")
      end

      it 'should render page inline' do
        act(true).should render_template(:inline)
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
    before { sign_in me }

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
      def act(attrs={})
        post(:update, :project_id=>project.id, :id=>subject.id, :suggestion=>Factory.attributes_for(:suggestion, attrs))
        assigns(:suggestion)
      end

      it_behaves_like 'protected action'
      
      it 'should redirect to project' do
        act
        response.should redirect_to project_url(project)
      end

      it 'should update attributes' do
        act(:status=>:done).status.should == :done
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

    describe '#get' do
      alias :act :do_get
      it_behaves_like 'protected action'
    end

    describe '#create' do
      alias :act :do_create
      it_behaves_like 'protected action'

      it 'should push the story' do
        sign_in me
        story.should_receive(:do_create!)
        do_create
      end
    end
  end


  context 'with user' do
    subject { Factory(:suggestion, :project => project) }
    before { sign_in me }

    describe 'editing' do
      def edit
        get(:edit, :project_id=>project.id, :id=>subject.id)
      end

      it 'should show form' do
        edit.should have_selector('form') do |f|
          f.should have_selector("input[name='suggestion[content]']")
        end
      end

      it 'should show custom values' do
        subject.field_values.create(:name=>'url', :value=>'google.com')
        edit.should have_selector('.field-value') do |v|
          v.should contain('google.com')
        end
      end

    end



    describe '#update' do
      def act(attrs={})
        post(:update, :project_id=>project.id, :id=>subject.id, :suggestion=>Factory.attributes_for(:suggestion, attrs))
        assigns(:suggestion)
      end
      it_behaves_like 'protected action'
      
      it 'should redirect to project' do
        sign_in me
        act
        response.should redirect_to project_url(project)
      end

      it 'should update attributes' do
        sign_in me
        act(:status=>:done).status.should == :done
      end
    end

  end

  describe 'PivotalTracker' do    
    def valid_story
      {'password'=>'123456', 'name'=>suggestion.content_brief, 'description'=>suggestion.content, 'email'=>me.email,'project_id'=>999}
    end
    before do
      story = Integrations::PivotalTracker::Story.new(valid_story)
      story.stub(:valid?).and_return(true)
      story.stub(:do_create!).and_return(true)
      Integrations::PivotalTracker::Story.stub(:new).and_return(story)
    end

    describe '#new' do
      def act
        get(:pivotal_story, :project_id=>project.id, :suggestion_id=>suggestion.id)
      end
      it_behaves_like 'protected action'

      it 'should render form' do
        sign_in me
        act.should have_selector('form')
      end

      it 'should prefil story' do
        sign_in me; act
        story = assigns(:story)
        story.name.should == suggestion.content_brief
        story.description.should == suggestion.content
        story.email.should == me.email
      end
    end

    describe '#create' do
      def act
        post(:pivotal_story, :project_id=>project.id, :suggestion_id=>suggestion.id, :integrations_pivotal_tracker_story => valid_story) 
      end
      it_behaves_like 'protected action'

      it 'should redirect to edit suggestion' do
        sign_in me
        act.should redirect_to edit_project_suggestion_url(project, suggestion)
      end
    end
  end


  describe '#destroy' do
    def act
      post :destroy, :id => suggestion.id, :project_id => project.id
    end

    it_behaves_like 'protected action'

    it 'should redirect to project' do
      sign_in me
      act.should redirect_to project_url(project)
    end      
  end
end
