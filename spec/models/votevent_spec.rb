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
#  index_votevents_on_ventpost_id  (ventpost_id)
#  index_votevents_on_user_id      (user_id)
#

require 'spec_helper'

describe Votevent do
  before(:each) do
    @user = Factory(:user)
    @ventpost = Factory(:ventpost, :user => @user)
    @attr = { :ventpost_id => @ventpost.id }
  end

  it 'should create a votevent' do
    lambda do
      @user.votevents.create!(@attr)
    end.should change(Votevent, :count).by(1)
  end

  describe 'validations' do
    it 'should have the ventpost id' do
      Votevent.new(@attr).should_not be_valid
    end

    it 'should have the user id' do
      Votevent.new(:user_id => @user.id).should_not be_valid
    end
  end

  describe 'associations' do
    before(:each) do
      @votevent = @user.votevents.create!(@attr)
    end

    describe 'user' do
      it 'should have a user method' do
        @votevent.should respond_to(:user)
      end

      it 'should be associated with the right ventpost' do
        @votevent.user_id.should == @user.id
        @votevent.user.should ==  @user
      end
    end

    describe 'ventvotes' do
      it 'should have a ventpost method' do
        @votevent.should respond_to(:ventpost)
      end

      it 'should be associated with the right ventpost' do
        @votevent.ventpost_id.should == @ventpost.id
        @votevent.ventpost.should ==  @ventpost
      end
    end
  end
end
