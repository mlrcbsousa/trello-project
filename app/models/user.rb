class User < ApplicationRecord
  require 'trello'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: [:trello]

  # Associations
  has_many :sprints, dependent: :destroy
  has_many :boards, dependent: :destroy

  # Validations
  validates :username,
            length: { in: 0..20 },
            allow_blank: false,
            # must be a word character (letter, number, underscore)
            format: { with: /\A(\w+)\z/ }

  # must be a-z or ' ' (case-insensitive)
  validates :full_name, allow_blank: false, format: { with: /\A([a-z \'\.']+)\z/i }
  validates :provider, :uid, :token, :secret, presence: true

  # login with trello
  def self.from_trello_omniauth(auth)
    user_params = user_params(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    # user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20] # Fake password for validation
      user.save
    end
    boards(auth.extra.raw_info, user)
    return user
  end

  # build user_params from omniauth response
  def self.user_params(auth)
    user_params = auth.slice(:provider, :uid)
    raw_info = auth.extra.raw_info
    user_params.merge! raw_info.slice(:email, :username)
    user_params[:trello_avatar_url] = "https://trello-avatars.s3.amazonaws.com/#{raw_info.avatarHash}/170.png"
    user_params[:full_name] = raw_info.fullName
    user_params.merge! auth.credentials.slice(:token, :secret)
    user_params.to_h
  end

  def self.boards(raw_info, user)
    # creates Board instances with idBoards from omniauth response
    # Rails.logger.info "========>>>>> #{raw_info.inspect}"
    raw_info[:idBoards].each do |board_id|
      ext_board = user.client.find(:boards, board_id)
      user.boards.create!(
        trello_ext_id: ext_board.id,
        name: ext_board.name,
        trello_url: ext_board.url
      )
    end
  end

  # create a client with ruby-trello gem to make requests to trello api
  def client
    @client ||= Trello::Client.new(
      consumer_key: ENV['TRELLO_KEY'],
      consumer_secret: ENV['TRELLO_SECRET'],
      oauth_token: token,
      oauth_token_secret: secret
    )
  end
end
