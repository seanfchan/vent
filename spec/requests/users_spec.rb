require 'spec_helper'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

describe "Users" do
  describe 'sign up' do
    it 'should have the correct labels' do
      visit signup_path
      response.should have_selector('div.field>label',
                                    :content => 'Screen Name')
      response.should have_selector('div.field>label',
                                    :content => 'Email')
      response.should have_selector('div.field>label',
                                    :content => 'Password')
      response.should have_selector('div.field>label',
                                    :content => 'Retype Password')
    end

    describe 'failure' do
      it 'should not make a new user' do
        lambda do
          visit signup_path
          fill_in 'Screen Name',      :with => ''
          fill_in 'Email',            :with => ''
          fill_in 'Password',         :with => ''
          fill_in 'Retype Password',  :with => ''
          click_button
          response.should render_template('users/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(User, :count)
      end
    end

    describe 'success' do
      it 'should make a new user' do
        lambda do
          visit signup_path
          fill_in 'Screen Name',     :with => "Sean"
          fill_in 'Email',           :with => "user@example.com"
          fill_in 'Password',        :with => "foobar"
          fill_in 'Retype Password', :with => "foobar"
          click_button
          response.should have_selector('div.flash.success', 
                                        :content => 'Welcome')
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
        DatabaseCleaner.clean
      end
    end
  end

  describe 'signin' do
    describe 'failure' do
      it 'should not sign a user in' do
        visit signin_path
        fill_in 'Email', :with => ''
        fill_in 'Password', :with => ''
        click_button
        response.should have_selector('div.flash.error', :content => 'Invalid')
        response.should render_template('sessions/new')
      end
    end

    describe 'success' do
      it 'should sign a user in and out' do
        user = Factory(:user)
        visit signin_path
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => user.password
        click_button
        controller.should be_signed_in
        click_link 'Sign out'
        controller.should_not be_signed_in
      end

      it 'should sign a admin in and out' do
        user = Factory(:user)
        visit signin_path
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => user.password
        click_button
        controller.should be_signed_in
        click_link 'Sign out'
        controller.should_not be_signed_in
        user.toggle!(:admin)
        visit signin_path
        fill_in 'Email', :with => user.email
        fill_in 'Password', :with => user.password
        click_button
        controller.should be_signed_in
      end
    end
  end
end
