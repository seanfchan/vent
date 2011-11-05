require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Vent"
  end

  describe "GET 'home'" do
    describe 'when not signed in' do
      it "should be successful" do
        get 'home'
        response.should be_success
      end

      it "should have the right title" do
        get 'home'
        response.should have_selector("title", 
                                      :content => "| Home")
      end

      it "should have a non-blank body" do
        get 'home'
        response.body.should_not =~ /<body>\s*<\/body>/
      end
    end


    describe 'when signed in' do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it 'should have the right title' do
        get :home
        response.should have_selector("title",
                                      :content => "| Feed")
      end

      it 'should have the right follower/following counts' do
        get :home
        response.should have_selector('a', :href => following_user_path(@user),
                                           :content => '0 following')
        response.should have_selector('a', :href => followers_user_path(@user),
                                           :content => '1 follower')
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", 
                                    :content => "#{@base_title} | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title", 
                                    :content => "#{@base_title} | About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title", 
                                    :content => "#{@base_title} | Help")
    end
  end

  describe "GET 'dump'" do
    # it 'should be successful' do
    #   get 'dump'
    #   response.should be_success
    # end

    # it 'should have the right title' do
    #   get 'dump'
    #   response.should have_selector("title",
    #                                 :content => "#{@base_title} | Dump")
    # end

    describe 'when not signed in' do
      it 'should not be successful' do
        get 'dump'
        response.should_not be_success
      end

      it 'should redirect to signin path' do
        get 'dump'
        response.should redirect_to(signin_path)
      end
    end

    describe 'when signed in' do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @second_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
        second_user_vent = Factory(:ventpost, :user => @second_user)
        @third_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
        third_user_vent = Factory(:ventpost, :user => @third_user)

        @user.follow!(@second_user)
      end

      it 'should be successful' do
        get 'dump'
        response.should be_success
      end

      it 'should have vents of followed users and non followed users' do
        get 'dump'
        response.should have_selector('a', :href => user_path(@second_user),
                                           :content => @second_user.name)
        response.should have_selector('a', :href => user_path(@third_user),
                                           :content => @third_user.name)
      end
    end
  end

end
