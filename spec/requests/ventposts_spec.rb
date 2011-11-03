require 'spec_helper'

describe "Ventposts" do
  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email, :with => @user.email
    fill_in :password, :with => @user.password
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

  describe 'vent post deletion' do
    before(:each) do
      second_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
      @second_user_vent = Factory(:ventpost, :user => second_user)
      @user.follow!(second_user)
    end

    describe 'failure' do
      it "should not be able to delete other user's vents" do
        visit root_path
        response.should_not have_selector('a', :href => ventpost_path(@second_user_vent),
                                               :content => 'delete')
      end
    end
  end

  describe 'dump page' do
    before(:each) do
      second_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
      third_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))

      @second_user_vent = Factory(:ventpost, :user => second_user, :created_at => 2.hour.ago)
      @third_user_vent = Factory(:ventpost, :user => third_user, :created_at => 1.hour.ago)
      @user.follow!(second_user)
    end

    it 'should show all vents from all users based on created_at' do
      visit dump_path
      response.should have_selector('span.content', :content => @second_user_vent.content)
      response.should have_selector('span.content', :content => @third_user_vent.content)
    end
  end
end
