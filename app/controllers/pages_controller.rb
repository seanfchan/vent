class PagesController < ApplicationController
  def home
  	@title = "Home"
    if signed_in?
      @title = "Feed"
      @ventpost = Ventpost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
      store_location
    end
  end

  def contact
  	@title = "Contact"
  end

  def about
  	@title = "About"
  end

  def help
    @title = "Help"
  end

  def dump
    @title = "Dump"
    @ventpost = Ventpost.new
    @feed_items = Ventpost.paginate(:page => params[:page])
    store_location
  end

end
