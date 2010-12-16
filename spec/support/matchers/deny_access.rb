RSpec::Matchers.define :deny_access do
  match do |response|
    @response = response
    [301, 302].include?(response.status) and 
      response.headers['Location'] == 'http://test.host/'
  end

  failure_message_for_should do |actual|
    "expected that the request to be denied, but was #{@response.status} with #{actual.headers}"
  end

  failure_message_for_should_not do |actual|
    "expected that the request not to be denied, but was #{@response.status} with #{actual.headers}"
  end

  description do
    "deny access"
  end

end
