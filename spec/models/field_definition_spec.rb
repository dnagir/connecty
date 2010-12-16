require 'spec_helper'

describe FieldDefinition do
  it { should belong_to(:project) }
  it { should validate_presence_of(:project_id) }
  it { should ensure_length_of(:name).is_at_least(3).is_at_most(50) }
  it { should ensure_length_of(:value).is_at_least(1).is_at_most(1024) }

  # should matcher doesn't work well here because of other validation errors
  context 'unique name validation' do
    let(:project)   { Factory(:project) }
    let(:existing)  { Factory(:field_definition, :project=>project) }

    it 'should not allow duplicates within a project' do
      FieldDefinition.new(:name=>existing.name, :project=>project).tap do |f|
        f.should_not be_valid
        f.should have(1).error_on(:name)
      end
    end
    it 'should allow same name for different project' do
      FieldDefinition.new(:name=>existing.name, :project=>Factory(:project)).tap do |f|
        f.valid?
        f.should have(:no).error_on(:name)
      end
    end
  end
end
