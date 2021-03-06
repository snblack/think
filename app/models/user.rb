class User < ApplicationRecord
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :facebook]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes

  # has_and_belongs_to_many :subscribes, class_name: "Question"
  has_many :subscribes
  has_many :questions

  def author_of?(resource)
    self.id == resource.user_id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth['provider'], uid: auth['uid'])
  end

end
