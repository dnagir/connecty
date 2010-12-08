RSpec::Matchers.define :deny_access do
  match do |response|
    #response.flash[:alert].should =~ /access/i
    #response.status.should == 302    
    response.should redirect_to '/' # How to get URL helper here?
  end

  failure_message_for_should do |actual|
    "expected that the request to be denied, but was #{actual.headers}"
  end

  failure_message_for_should_not do |actual|
    "expected that the request not to be denied, but was #{actual.headers}"
  end

  description do
    "deny access"
  end

end
