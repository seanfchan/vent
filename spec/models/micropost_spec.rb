# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Micropost do
  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "foobar" }
  end

  it 'should create a new instance with valid attributes' do
    @user.microposts.create!(@attr)
  end

  describe 'user associations' do
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it 'should have a user attribute' do
      @micropost.should respond_to(:user)
    end

    it 'should have the correct associated user' do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end

  describe 'validations' do
    it 'should the user id' do
      Micropost.new(@attr).should_not be_valid
    end

    it 'should require a non blank content' do
      @user.microposts.build(:content => '  ').should_not be_valid
    end

    it 'should reject content that is too long' do
      @user.microposts.build(:content => 'a' * 201).should_not be_valid
    end
  end
end
