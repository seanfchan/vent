class VentpostsController < ApplicationController
  before_filter :authenticate
  before_filter :authorize_user, :only => [:destroy]

  def create
    @ventpost = current_user.ventposts.build(params[:ventpost])
    if @ventpost.save
      redirect_to root_path, :flash => { :success => 'You vented successfully! :)'}
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @ventpost.destroy
    redirect_to root_path, :flash => { :success => 'Vent deleted!' }
  end

private
  def authorize_user
    @ventpost = Ventpost.find(params[:id])
    redirect_to root_path unless current_user?(@ventpost.user)
  end
end