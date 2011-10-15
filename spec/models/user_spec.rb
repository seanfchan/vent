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
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
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
end
