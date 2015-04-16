require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  describe 'create' do
    it 'should create a user' do

      request.env["omniauth.auth"] = omniauth_hash
      post :create, { 'provider' => 'github' }

      expect(response).to redirect_to root_url
      user = User.find_by_uid(1234)
      expect(user).to be_truthy
      expect(session[:user_id]).to eql(user.id)
    end

    it 'should log out a user' do
      request.env["omniauth.auth"] = omniauth_hash
      post :create, { 'provider' => 'github' }

      user = User.find_by_uid(1234)
      expect(session[:user_id]).to eql(user.id)
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
  end

  def omniauth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
    :provider => 'github',
    :uid => '1234',
    :info => {
      :name => 'Dude',
      :email => 'dude@woot.com'
    },
    :credentials => {:token => 'T0k3N'}
    })
  end


end
