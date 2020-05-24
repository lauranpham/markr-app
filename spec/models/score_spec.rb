require 'rails_helper'

RSpec.describe Score, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # Association test
  it { should belong_to(:result) }
  it { should belong_to(:student) }
  # Validation test
  [:obtained, :available, :result, :student].each do |field|
    it { should validate_presence_of(field) }
  end
end
