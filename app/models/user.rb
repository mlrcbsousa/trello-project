class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: [:trello]

    # where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #   user.email = auth.info.email
    #   user.password = Devise.friendly_token[0, 20]
    #   user.full_name = auth.info.fullName
    #   # user.image = auth.info.image # assuming the user model has an image
    # end

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
