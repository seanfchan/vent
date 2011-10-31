require 'spec_helper'

describe "FriendlyForwardings" do
  it 'should foward to the requested page after signin' do
    user = Factory(:user)
    visit edit_user_path(user)
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
    response.should render_template('users/edit')
    visit signout_path
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
    response.should render_template('home')
  end

  it 'should forward to the original page the vent was posted at' do
    user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
    visit root_path
    fill_in :ventpost_content,  :with => 'home'
    click_button
    response.should render_template('home')
    visit dump_path
    fill_in :ventpost_content, :with => 'dump'
    click_button
    response.should render_template('dump')
  end
end
