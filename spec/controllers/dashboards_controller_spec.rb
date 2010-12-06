require 'spec_helper'

describe DashboardsController do
  render_views
  let(:me) { Factory(:user) }

  describe "GET 'show'" do
    context 'as anonim' do
      it 'should ask to log-in' do
        get(:show).should redirect_to(new_user_session_url)
      end
    end

    context 'as logged-in user' do
      before do
        sign_in me
      end

      it "should be successful" do
        get :show
        response.should be_success
      end

      it 'should show projects' do
        3.times { Factory.create(:project, :users=>[me]) }
        get(:show).should have_selector('.project', :count => 3)
      end
    end
  end

end
