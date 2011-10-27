# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { 
      :name => 'User', 
      :email => 'user@example.com',
      :password => 'foobar',
      :passwor_confirmation => 'foobar'
    }
  end

  it 'should create a new instance given a valid atrribute' do
    User.create!(@attr)
  end

  it 'should require a name' do
    no_name_user = User.new(@attr.merge(:name => ''))
    no_name_user.should_not be_valid
  end

  it 'should require an email' do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end

  it 'should reject names that are too long' do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it 'should accept valid email addresses' do 
    addresses = %w[sean@foo.com DA_SEAN@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid email addresses' do
    addresses = %w[sean@foo,com DA_SEAN_at_foo.bar.org bull.shit@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it 'should reject duplicate email address' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it 'should reject email addresses identical up to case' do
    upcase_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcase_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe 'passwords' do
    before(:each) do
      @user = User.new(@attr)
    end

    it 'should have a password attribute' do
      @user.should respond_to(:password)
    end

    it 'should have a password confirmation atrribute' do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe 'password validations' do
    it 'should require a password' do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).
        should_not be_valid
    end

    it 'should require a matching password confirmation' do
      User.new(@attr.merge(:password_confirmation => 'invalid')).
        should_not be_valid
    end

    it 'should reject short passwords' do
      short_password = 'a' * 5
      hash = @attr.merge(:password => short_password, :password_confirmation => short_password)
      User.new(hash).should_not be_valid
    end

    it 'should reject long passwords' do
      long_password = 'a' * 41
      hash = @attr.merge(:password => long_password, :password_confirmation => long_password)
      User.new(hash).should_not be_valid
    end
  end

  describe 'password encryption' do
    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should have an encrypted password attribute' do
      @user.should respond_to(:encrypted_password)
    end

    it 'should set the encrypted password attribute' do
      @user.encrypted_password.should_not be_blank
    end

    it 'should have a salt attribute' do
      @user.should respond_to(:salt)
    end

    it 'should set the salt attribute' do
      @user.salt.should_not be_blank
    end

    describe 'has_password? method' do
      it 'should exist' do
        @user.should respond_to(:has_password?)
      end

      it 'should return true if the passwords match' do
        @user.has_password?(@attr[:password]).should be_true
      end

      it 'should return false if the passwords do not match' do
        @user.has_password?('invalid').should be_false
      end
    end

    describe 'authenticate method' do
      it 'should exist' do
        User.should respond_to(:authenticate)
      end

      it 'should return nil on email/password mismatch' do
        User.authenticate(@attr[:email], 'wrongpass').should be_nil
      end

      it 'should return nil for an email address with no user' do
        User.authenticate('bar@foo.com', @attr[:password]).should be_nil
      end

      it 'should return the user on email/password match' do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end

  describe 'admin attribute' do
    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should respond to admin' do
      @user.should respond_to(:admin)
    end

    it 'should not be an admin by default' do
      @user.should_not be_admin
    end

    it 'should be convertible to an admin' do 
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  # Ventpost associations
  describe  'ventpost associations' do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:ventpost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:ventpost, :user => @user, :created_at => 1.hour.ago)
    end

    it 'should have a ventpost attribute' do
      @user.should respond_to(:ventposts)
    end

    it 'should have the right ventposts in the right order' do
      @user.ventposts.should == [@mp2, @mp1]
    end

    it 'destroy associated ventposts' do
      @user.destroy
      [@mp1, @mp2].each do |ventpost|
        Ventpost.find_by_id(ventpost.id).should be_nil
      end
    end

    describe 'status feed' do
      it 'should have a feed' do
        @user.should respond_to(:feed)
      end

      it "should include the user's vent posts" do
        @user.feed.should include(@mp1)
        @user.feed.should include(@mp2)
      end

      it "should not include a different user's vent post" do
        mp3 = Factory(:ventpost, 
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.should_not include(mp3)
      end
    end
  end

  describe 'relationships' do
    before(:each) do
      @user = User.create!(@attr)
      @followed = Factory(:user)
      @follower = Factory(:user, :email => Factory.next(:email))
    end

    it 'should respond to the relationships method' do
      @user.should respond_to(:relationships)
    end

    it 'should have a following method' do
      @user.should respond_to(:following)
    end

    it 'should follow another user' do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it 'should include the followed user in the following array' do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end

    it 'should have an unfollow! method' do
      @user.should respond_to(:unfollow!)
    end

    it 'should be able to unfollow a user' do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end

    it 'should have a reverse_relationships method' do
      @user.should respond_to(:reverse_relationships)
    end

    it 'should have a followers method' do
      @user.should respond_to(:followers)
    end

    it 'should include the follower in the followers array' do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
  end
end

