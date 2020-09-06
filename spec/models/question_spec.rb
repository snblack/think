require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:answers).dependent(:delete_all) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
