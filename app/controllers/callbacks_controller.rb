class CallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :verify_authenticity_token, :only => [:google]

  def google
    @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)

    if !@user.nil? and @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:warning] = I18n.t "devise.omniauth_callbacks.failure", :kind => "Google", :reason => 'Account not found.'
      sign_out_and_redirect login_path
    end
  end
end