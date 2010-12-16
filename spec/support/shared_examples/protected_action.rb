
shared_examples_for "protected action" do |args = {}|

  def run_protected_action
    action_name = [:act, :result, :edit, :update, :create, :new, :destroy, :delete].find do |action|
      respond_to? action
    end
    send(action_name)
  end

  it "should ask to log-in" do
    sign_out :user
    run_protected_action
    response.should require_authentication
  end

  # if there is no resource to check then we cannot test other users
  unless args[:with] == :no_resource
    it "should deny access to other users" do
      sign_in Factory(:user)
      run_protected_action
      response.should deny_access
    end
  end

  it "should allow access to myself" do
    sign_in respond_to?(:me) ? me : current_user
    run_protected_action
    response.should_not require_authentication
    response.should_not deny_access
  end
end

