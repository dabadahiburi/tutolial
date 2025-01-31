class PasswordResetController < ApplicationController
  before_action :get_user,          only:[:edit,:update]
  before_action :valid_user,        only:[:edit,:update]
  before_action :check_expiration,  only:[:edit,:update]#パスワード再設定の有効期限が切れていないか



  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password.empty?] #新しいパスワードが空文字列になっていないか (ユーザー情報の編集ではOKだった)
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params) #新しいパスワードが正しければ、更新する
      log_in @user
      flash[:syccess] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'#無効なパスワードであれば失敗させる (失敗した理由も表示する)
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user =User.find_by(email: params[:email])
    end
    #正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated? (:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
