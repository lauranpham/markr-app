require 'rails_helper'

RSpec.describe Result, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # Association test
  it { should have_many(:scores) }
  # Validation test
  it { should validate_presence_of(:id) }
end
