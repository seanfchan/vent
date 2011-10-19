class VentpostsController < ApplicationController
  before_filter :authenticate

  def create
    @ventpost = current_user.ventposts.build(params[:ventpost])
    if @ventpost.save
      redirect_to root_path, :flash => { :success => 'You vented successfully! :)'}
    else
      render 'pages/home'
    end
  end

  def destroy

  end

end