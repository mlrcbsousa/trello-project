# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def trello
    auth_hash = request.env["omniauth.auth"]
    @user = User.from_trello_omniauth(auth_hash)

    @boards = []
    auth_hash.extra.raw_info.slice(:idBoards).values.each do |board_id|

      Thread.new do
        @boards << {
          name: @user.client.find(:boards, board_id).name,
          board_id: board_id
        }
      end

    end

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Trello") if is_navigational_format?
    else
      session["devise.trello_data"] = auth_hash
      redirect_to new_user_registration_url
    end
  end

  def sprint_options(user)
  end

  def failure
    redirect_to root_path
  end
end
