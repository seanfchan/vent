require 'spec_helper'

describe VoteventsController do
  describe 'access control' do
    it 'should require signing in for create' do
      post :create
      response.should redirect_to(signin_path)
    end
  end

  describe "POST create" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @second_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
      @ventpost = Factory(:ventpost, :user => @user)
      @ventpost2 = Factory(:ventpost, :user => @second_user)
    end

    describe "success" do
      it 'should create a votevent' do
        lambda do
          post :create, :ventpost_id => @ventpost2
        end.should change(Votevent, :count).by(1)
      end
    end

    describe "failure" do
      it 'should not allow a user to vote on their own ventpost' do
        lambda do
          post :create, :ventpost_id => @ventpost
          response.should redirect_to(root_path)
        end.should_not change(Votevent, :count)
      end
    end
  end
end