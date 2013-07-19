class UsersController < ApplicationController

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:user, :email, :password, :password_confirmation)
  end

end
