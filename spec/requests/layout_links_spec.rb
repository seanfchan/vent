require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => 'Home')
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => 'Contact')
  end

  it "should have a About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => 'About')
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => 'Help')
  end

  it "should have a Signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => 'Sign up')
  end

  it "should have a Sign in page at '/signin'" do
    get '/signin'
    response.should have_selector('title', :content => 'Sign in')
  end

  it "should have the right links on the layout" do
    visit root_path
    response.should have_selector('title', :content => "Home")
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Sign up NOW!"
    response.should have_selector('title', :content => "Sign up")
    response.should have_selector('a[href="/"]>img')
  end

  describe 'when not signed in' do
    it 'should have a signin link' do
      visit root_path
      response.should have_selector('a', :href => signin_path,
                                         :content => 'Sign in')
    end

    it 'should have a home link' do
      visit root_path
      response.should have_selector('a', :href => root_path,
                                         :content => 'Home')
    end
  end

  describe 'when signed in' do
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it 'should have a dump link' do
      visit root_path
      response.should have_selector('a', :href => dump_path,
                                         :content => 'Dump')
    end

    it 'should have a feed link' do
      visit root_path
      response.should have_selector('a', :href => root_path,
                                         :content => 'Feed')
    end

    it 'should have a signout link' do
      visit root_path
      response.should have_selector('a', :href => signout_path,
                                         :content => 'Sign out')
    end

    it 'should have a profile link' do
      visit root_path
      response.should have_selector('a', :href => user_path(@user),
                                         :content => 'Profile')
    end

    it 'should have a settings link' do
      visit root_path
      response.should have_selector('a',  :href => edit_user_path(@user),
                                          :content => 'Settings')
    end

    # it 'should ahve a users link' do
    #   visit root_path
    #   response.should have_selector('a', :href => users_path,
    #                                      :content => 'Users')
    # end
    
    describe 'as admin' do
      before(:each) do
        @user.toggle!(:admin)
        @user_vent = Factory(:ventpost, :user => @user)
        second_user = Factory(:user, :email => Factory.next(:email))
        @second_user_vent = Factory(:ventpost, :user => second_user)
        @user.follow!(second_user)
      end

      it "should show delete link for admin's vents" do
        visit root_path
        response.should have_selector('a', :href => ventpost_path(@user_vent),
                                           :content => 'delete')
      end

      it "should show delete link for other user's vents" do
        visit root_path
        response.should have_selector('a', :href => ventpost_path(@second_user_vent),
                                           :content => 'delete')
      end
    end
  end
end
