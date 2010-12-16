RSpec::Matchers.define :require_authentication do
  match do |response|
    @response = response
    [301, 302].include?(response.status) and 
      response.headers['Location'].to_s =~ /\/users\/sign_in/
  end

  failure_message_for_should do |actual|
    "expected to require authentication, but was #{@response.status} with #{actual.headers}"
  end

  failure_message_for_should_not do |actual|
    "expected NOT to require authentication, but was #{@response.status} with #{actual.headers}"
  end

  description do
    "require authentication"
  end

end

