RSpec::Matchers.define :require_authentication do
  match do |response|
    response.should redirect_to '/users/sign_in' # cannot use Rails url-helpers for some reason
  end

  failure_message_for_should do |actual|
    "expected to require authentication, but was #{actual.headers}"
  end

  failure_message_for_should_not do |actual|
    "expected NOT to require authentication, but was #{actual.headers}"
  end

  description do
    "require authentication"
  end

end

