class SessionsController < ApplicationController
  def new
    @title = 'Sign in'
    @user = User.new
  end

  def create

  end

  def destroy

  end

end
