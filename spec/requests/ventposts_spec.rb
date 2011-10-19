require 'spec_helper'

describe "Ventposts" do
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end

  describe 'vent post creation' do
    describe 'failure' do
      it 'should not make a new micropost' do
        lambda do
          visit root_path
          fill_in  :ventpost_content, :with => ''
          click_button
          response.should render_template('pages/home')
          response.should have_selector('div#error_explanation')
        end.should_not change(Ventpost, :count)
      end
    end

    describe 'success' do
      it 'should make a new micropost' do
        content = 'Hi, whats up everybody hahahah this is fun, i\'m so fucking tired !'
        lambda do
          visit root_path
          fill_in :ventpost_content, :with => content
          click_button
          response.should have_selector('span.content', :content => content)
        end.should change(Ventpost, :count).by(1)
      end
    end
  end
end
