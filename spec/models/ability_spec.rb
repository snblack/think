require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question}
    let(:question_with_user) { create :question, user: user}


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Vote }
    it { should be_able_to :up, Question }
    it { should be_able_to :down, Question }
    it { should be_able_to :up, Answer }
    it { should be_able_to :down, Answer }

    it { should be_able_to :update, question_with_user }
    it { should_not be_able_to :update, create(:question, user: other) }
    it { should be_able_to :update, create(:answer, question: question, user: user) }
    it { should_not be_able_to :update, create(:answer, question: question, user: other) }

    it { should be_able_to :destroy, question_with_user }
    it { should_not be_able_to :destroy, create(:question, user: other) }
    it { should be_able_to :destroy, create(:answer, question: question, user: user) }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }

    it { should be_able_to :destroy, create(:link, linkable: question_with_user) }
    it { should_not be_able_to :destroy, create(:link, linkable: question) }

    it { should be_able_to :mark_as_best, create(:answer, question: question_with_user, user: other)}
    it { should_not be_able_to :mark_as_best, create(:answer, question:question, user: user) }

    it { should be_able_to :update, create(:answer, question: question, user: user) }
    it { should_not be_able_to :update, create(:answer, question: question, user: other) }
  end
end
