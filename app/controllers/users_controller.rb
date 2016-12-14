class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index]

  def index
    @users = User.where.not(id: current_user.id)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attribute(:role, params[:role])
      redirect_to users_url, notice: "This user's role was successfully changed."
    else
      redirect_to users_url, notice: 'Something went wrong.'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "This user's account was successfully deleted." }
      format.json { head :no_content }
    end
  end
end
