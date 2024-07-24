require 'rails_helper'

RSpec.describe Result, type: :model do
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:timestamp) }
  it { should validate_presence_of(:marks) }
end
