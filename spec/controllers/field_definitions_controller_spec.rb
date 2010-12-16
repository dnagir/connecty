require 'spec_helper'

describe FieldDefinitionsController do
  render_views
  let(:me) { Factory.create(:user) }
  let(:project) { Factory.create(:project, :users=>[me]) }
  let(:field) { Factory(:field_definition, :project=>project) }

  describe '#index' do
    def index
      get(:index, :project_id=>project.id)
    end

    it_behaves_like 'protected action'
    
    context 'as a user' do
      before { sign_in me }

      it 'should list all fields' do
        3.times { Factory(:field_definition, :project=>project) }
        index.should have_selector('.field_definition', :count => 3)
      end
    end
  end


  describe '#new' do
    def new
      get(:new, :project_id=>project.id)
    end

    it_behaves_like 'protected action'
    
    context 'as a user' do
      before { sign_in me }

      it 'should have form' do new.should have_selector('form') end
    end
  end


  describe '#edit' do
    def edit
      get(:edit, :project_id=>project.id, :id=>field.id)
    end

    it_behaves_like 'protected action'
    
    context 'as a user' do
      before { sign_in me }

      it 'should have form' do edit.should have_selector('form') end
    end
  end


  describe '#create' do
    def create
      post(:create, :project_id=>project.id, :field_definition=>Factory.attributes_for(:field_definition))
    end

    it_behaves_like 'protected action'
    
    context 'as a user' do
      before { sign_in me }

      specify { create.should redirect_to project_field_definitions_url(project) }
    end
  end


  describe '#update' do
    def update(attrs={})
      post(:update, :project_id=>project.id, :id=>field.id, :field_definition=>Factory.attributes_for(:field_definition, attrs))
    end

    it_behaves_like 'protected action'
    
    context 'as a user' do
      before { sign_in me }

      specify { update.should redirect_to project_field_definitions_url(project) }
      it 'should update field' do
        update(:name=>'new name')
        field.reload.name.should == 'new name'
      end
    end
  end


  describe '#destroy' do
    def act
      post(:destroy, :project_id=>project.id, :id=>field.id)
    end

    it_behaves_like 'protected action'
    
    context 'as a user' do
      before { sign_in me }

      specify { act.should redirect_to project_field_definitions_url(project) }
      it 'should delete field' do
        field # make sure field is created before testing it
        expect { act }.to change { project.field_definitions(true).count }.by(-1)
      end
    end
  end

end

