require 'rails_helper'

RSpec.describe Test, type: :model do
  it { should validate_presence_of :title }

  it { should have_many(:questions) }
end
