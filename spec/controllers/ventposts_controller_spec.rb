require 'spec_helper'

describe VentpostsController do
  render_views

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe 'failure' do
      before(:each) do
        @attr = { :content => '' }
      end

      it 'should not create a vent post' do
        lambda do
          post :create, :ventpost => @attr
        end.should_not change(Ventpost, :count)
      end

      it 'should rerender the home page' do
        post :create, :ventpost => @attr
        response.should render_template('pages/home')
      end
    end

    describe 'success' do
      before(:each) do
        @attr = { :content => 'foobar' }
      end

      it 'should create a vent post' do
        lambda do
          post:create, :ventpost => @attr
        end.should change(Ventpost, :count).by(1)
      end

      it 'should redirect to the root path' do
        post :create, :ventpost => @attr
        response.should redirect_to(root_path)
      end

      it 'should display a flash success message' do
        post :create, :ventpost => @attr
        flash[:success].should =~ /successfully/i
      end

    end
  end

  describe "DELETE 'destroy'" do

  end

  describe 'access control' do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

end