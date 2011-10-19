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

  describe 'validations' do
    it 'should the user id' do
      Ventpost.new(@attr).should_not be_valid
    end

    it 'should require a non blank content' do
      @user.ventposts.build(:content => '  ').should_not be_valid
    end

    it 'should reject content that is too long' do
      @user.ventposts.build(:content => 'a' * 201).should_not be_valid
    end
  end
end