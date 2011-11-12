class VoteventsController < ApplicationController
  before_filter :authenticate
  before_filter :self_vote, :only => [:create]

  def create
    current_user.vote!(@ventpost)

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

private 
  def self_vote
    @ventpost = Ventpost.find(params[:ventpost_id])
    
    if current_user == @ventpost.user
      redirect_to root_path
      flash[:error] = "You can't vote for your own vent"
    end
  end
end