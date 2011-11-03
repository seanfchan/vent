class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]

  def index
    @users = User.paginate(:page => params[:page])
    @title = 'All users'
  end

  def show
    @user = User.find(params[:id])
    @ventposts = @user.ventposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
   @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to user_path(@user), :flash => { :success => "Welcome to ProtoVent!" }
    else
      @title = 'Sign up'
      render 'new'
    end
  end

  def edit
    @title = 'Edit user'
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => 'Your profile has successfully been updated.' }
    else
      @title = 'Edit user'
      render 'edit'
    end
  end

  def destroy
    user_name = @user.name
    @user.destroy
    redirect_to users_path, :flash => { :success => "User #{user_name} deleted." }
  end

private
  def correct_user
    @user = User.find(params[:id])
    unless (current_user?(@user))
      redirect_to(root_path)
      flash_permission_denied
    end
    # redirect_to(root_path), :flash => { :error => 'Permission denied' } unless current_user?(@user)
  end

  def admin_user
    @user = User.find(params[:id])
    if (!current_user.admin? || current_user?(@user))
      redirect_to(root_path)
      flash_permission_denied
    end
  end

end
