require 'spec_helper'

describe "Votevents" do
  before(:each) do
    @user = Factory(:user)
    @second_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
    @third_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
    @ventpost = Factory(:ventpost, :user => @user)
    @ventpost2 = Factory(:ventpost, :user => @second_user)
    @ventpost3 = Factory(:ventpost, :user => @third_user)
    @user.follow!(@second_user)
    visit signin_path
    fill_in :email, :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  describe "failure" do
    before(:each) do
      @user.vote!(@second_user)
    end

    it 'should not see the vote link for a vent created by the current user' do
      visit root_path
      response.should_not have_selector("div#upvoteicon#{@ventpost.id}")
    end

    it "should not see the vote link for vents that current user has already voted for" do
      visit root_path
      response.should_not have_selector("div#upvoteicon#{@ventpost2.id}")
    end

    it 'should have the vote counter' do
      visit root_path
      response.should have_selector("div#upvotecount#{@ventpost2.id}")
    end
  end

  describe "success" do
    it "should have the upvoteicon" do
      visit root_path
      response.should have_selector("div#upvoteicon#{@ventpost2.id}")
    end

    it "should have the vote counter" do
      visit root_path
      response.should have_selector("div#upvotecount#{@ventpost2.id}",
                                    :content => "0 votes")
    end
  end

  it "should not show vote icon after voting for a specific vent" do
    visit root_path
    response.should have_selector("div#upvoteicon#{@ventpost2.id}")
    response.should have_selector("div#upvotecount#{@ventpost2.id}")
    response.should have_selector("div#upvotecount#{@ventpost2.id}",
                                    :content => "0 votes")
    @user.vote!(@ventpost2)
    visit root_path
    response.should_not have_selector("div#upvoteicon#{@ventpost2.id}")
    response.should have_selector("div#upvotecount#{@ventpost2.id}",
                                    :content => "1 vote")
    visit dump_path
    response.should have_selector("div#upvoteicon#{@ventpost3.id}")
    response.should have_selector("div#upvotecount#{@ventpost3.id}")
    response.should have_selector("div#upvotecount#{@ventpost3.id}",
                                    :content => "0 votes")
  end

  it "should report the correct vote count" do
    visit root_path
    response.should have_selector("div#upvoteicon#{@ventpost2.id}")
    response.should have_selector("div#upvotecount#{@ventpost2.id}")
    response.should have_selector("div#upvotecount#{@ventpost2.id}",
                                    :content => "0 votes")
    @user.vote!(@ventpost2)
    @third_user.vote!(@ventpost2)
    visit root_path
    response.should_not have_selector("div#upvoteicon#{@ventpost2.id}")
    response.should have_selector("div#upvotecount#{@ventpost2.id}",
                                    :content => "2 votes")
  end
end
