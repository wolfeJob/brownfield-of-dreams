class UsersController < ApplicationController
  def show
    @github = GithubFacade.new(current_user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserActivationMailer.activate(@user).deliver_now
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      flash[:error] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def confirm_email
    user = User.find_by(confirm_token: params[:id])
    if user
      user.activate
      flash[:success] = "Confirmed!"
      redirect_to dashboard_path
    else
      flash[:error] = "User does not exist"
      redirect_to root_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password)
    end
end
