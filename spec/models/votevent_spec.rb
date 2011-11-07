# == Schema Information
#
# Table name: votevents
#
#  id          :integer         not null, primary key
#  ventpost_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_votevents_on_user_id      (user_id)
#  index_votevents_on_ventpost_id  (ventpost_id)
#

require 'spec_helper'

describe Votevent do
  before(:each) do
    @user = Factory(:user)
    @ventpost = Factory(:ventpost, :user => @user)
    @attr = { :user_id => @user.id }
  end

  it 'should create a votevent' do
    lambda do
      @ventpost.votevents.create!(@attr)
    end.should change(Votevent, :count).by(1)
  end

  describe 'validations' do
    it 'should have the user id' do
      Votevent.new(@attr).should_not be_valid
    end

    it 'should have the ventpost id' do
      Votevent.new(:user_id => @user.id).should_not be_valid
    end
  end

  describe 'ventpost associations' do
    before(:each) do
      @votevent = @ventpost.votevents.create!(@attr)
    end

    it 'should have a ventpost method' do
      @votevent.should respond_to(:ventpost)
    end

    it 'should be associated with the right ventpost' do
      @votevent.ventpost_id.should == @ventpost.id
      @votevent.ventpost.should ==  @ventpost
    end

  end
end
