class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @users = User.paginate(:page => params[:page])
    @title = 'All users'
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
   @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to user_path(@user), :flash => { :success => "Welcome to Vent!" }
    else
      @title = 'Sign up'
      render 'new'
    end
  end

  def edit
    @user  = User.find(params[:id])
    @title = 'Edit user'
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => 'Your profile has successfully been updated.' }
    else
      @title = 'Edit user'
      render 'edit'
    end
  end

private
  def authenticate
    # flash[:notice] = 'Please sign in to access this page.'
    # The assignment above is included in the line below
     deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    unless (current_user?(@user))
      redirect_to(root_path)
      flash[:error] = 'Permission denied.'
    end
    # redirect_to(root_path), :flash => { :error => 'Permission denied' } unless current_user?(@user)
  end

end
