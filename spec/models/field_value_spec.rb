require 'spec_helper'

describe FieldValue do
  it { should belong_to(:suggestion) }
end
