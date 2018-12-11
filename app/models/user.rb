class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: [:trello]

  # Associations
  has_many :sprints, dependent: :destroy

  # Validations
  validates :username,
            length: { in: 0..20 },
            allow_blank: false,
            # must be a word character (letter, number, underscore)
            format: { with: /\A(\w+)\z/ }

  # must be a-z or ' ' (case-insensitive)
  validates :full_name, allow_blank: false, format: { with: /\A([a-z \'\.']+)\z/i }
  validates :provider, :uid, :token, :secret, presence: true

  def self.from_trello_omniauth(auth)
    user_params = auth.slice(:provider, :uid)
    user_params.merge! auth.extra.raw_info.slice(:email, :username)
    user_params[:trello_avatar_url] = auth.extra.raw_info.avatarUrl
    user_params[:full_name] = auth.extra.raw_info.fullName
    user_params.merge! auth.credentials.slice(:token, :secret)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20] # Fake password for validation
      user.save
    end
    return user
  end
end
