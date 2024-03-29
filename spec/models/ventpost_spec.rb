# == Schema Information
#
# Table name: ventposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_ventposts_on_user_id  (user_id)
#

require 'spec_helper'

describe Ventpost do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "foobar" }
  end

  it 'should create a new instance with valid attributes' do
    @user.ventposts.create!(@attr)
  end

  describe 'user associations' do
    before(:each) do
      @ventpost = @user.ventposts.create(@attr)
    end

    it 'should have a user attribute' do
      @ventpost.should respond_to(:user)
    end

    it 'should have the correct associated user' do
      @ventpost.user_id.should == @user.id
      @ventpost.user.should == @user
    end
  end

  describe 'votevents' do
    before(:each) do
      @second_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
      @third_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
      @ventpost = Factory(:ventpost, :user => @user)
      @ventpost2 = Factory(:ventpost, :user => @second_user)
      @votevent = @user.votevents.create(:ventpost_id => @ventpost.id)
      @votevent2 = @second_user.votevents.create(:ventpost_id => @ventpost.id)
      @votevent3 = @third_user.votevents.create(:ventpost_id => @ventpost2.id)
    end

    it 'should have a ventvotes method' do
      @ventpost.should respond_to(:ventvotes)
    end

    it 'should have a votes? method' do
      @ventpost.should respond_to(:voted?)
    end

    it 'should ahve the right number of ventvotes' do
      @ventpost.ventvotes.count.should == 2
    end

    it 'should have the right ventvotes' do
      @ventpost.ventvotes.should == [@votevent, @votevent2]
    end

    it 'should not have ventpost with differnt id' do
      @ventpost.ventvotes.should_not include(@votevent3)
    end
  end

  describe 'validations' do
    it 'should have the user id' do
      Ventpost.new(@attr).should_not be_valid
    end

    it 'should require a non blank content' do
      @user.ventposts.build(:content => '  ').should_not be_valid
    end

    it 'should reject content that is too long' do
      @user.ventposts.build(:content => 'a' * 201).should_not be_valid
    end
  end

  describe 'from_users_followed_by' do
    before(:each) do
      @second_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
      @third_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))

      @user_post = @user.ventposts.create!(:content => 'foo')
      @second_post = @second_user.ventposts.create!(:content => 'bar')
      @third_post = @third_user.ventposts.create!(:content => 'baz')

      @user.follow!(@second_user)
    end

    it 'should have a from_users_followed_by method' do
      Ventpost.should respond_to(:from_users_followed_by)
    end

    it 'should include the followed users ventposts' do
      Ventpost.from_users_followed_by(@user).
        should include(@second_post)
    end

    it "should include the user's own ventposts" do
      Ventpost.from_users_followed_by(@user).
        should include(@user_post)
    end

    it "should not include an unfollowed user's vent posts" do
      Ventpost.from_users_followed_by(@user).
        should_not include(@third_post)
    end
  end
end
