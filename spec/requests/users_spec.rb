require 'spec_helper'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

describe "Users" do
  describe 'sign up' do
    describe 'failue' do
      it 'should not make a new user' do
        lambda do
          visit signup_path
          fill_in 'Name',         :with => ''
          fill_in 'Email',        :with => ''
          fill_in 'Password',     :with => ''
          fill_in 'Confirmation', :with => ''
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
          fill_in 'Name',         :with => "Sean"
          fill_in 'Email',        :with => "user@example.com"
          fill_in 'Password',     :with => "foobar"
          fill_in 'Confirmation', :with => "foobar"
          click_button
          response.should have_selector('div.flash.success', 
                                        :content => 'Welcome')
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
        DatabaseCleaner.clean
      end
    end

  end
end
