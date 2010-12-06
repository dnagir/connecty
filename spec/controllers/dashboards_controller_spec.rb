require 'spec_helper'

describe DashboardsController do
  render_views
  let(:me) { Factory(:user) }
  
  describe "GET '#show'" do
    it 'should ask to log-in' do
      sign_out :user
      get(:show).should redirect_to new_user_session_url
    end

    context 'as logged-in user' do
      before do
        sign_in me
      end

      it 'should list all user projects' do
        3.times { Factory.create(:project, :users => [me]) }
        get(:show).should have_selector('.project', :count => 3)
      end

      it 'should not list projects of other users' do
        3.times { Factory.create(:project) }
        get(:show).should_not have_selector('.project')
      end
    end
  end


end
