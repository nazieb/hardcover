require 'rails_helper'

RSpec.describe ReposController, :type => :controller do

  before(:each) do
    session[:user_id] = nil
    @user = nil
  end

  describe '#index' do
    it 'should response successful' do
      session[:user_id] = user.id
      get :index
      expect(response).to be_success
    end
  end

  describe '#fetch_repos' do
    it 'should redirect to root path if user is not logged in' do
      get :fetch_repos
      expect(response).to redirect_to(root_path)
    end

    it 'should redirect to repos path if user is logged in' do
      allow_any_instance_of(User).to receive(:fetch_repos).and_return(nil)
      session[:user_id] = user.id
      get :fetch_repos
      expect(response).to redirect_to(repos_path)
    end
  end

  describe '#index' do
    it 'should show a repo if user is logged in' do
      session[:user_id] = user.id
      repo.save

      get :index, org: "octocat"
      expect(response).to be_success
      expect(assigns(:repos))
    end

    it 'should show a repo if user is logged out' do
      session[:user_id] = nil
      repo.save

      get :index, org: "octocat"
      expect(response).to be_success
      expect(assigns(:repos))
    end

    it 'should respond with 404 if repo does not exist' do
      assert_raises(ActiveRecord::RecordNotFound) do
        get :index, org: "some"
      end
    end
  end

  def repo
    return @repo if @repo
    json = JSON.parse(File.read("spec/fixtures/gh_repo.json"), :symbolize_names => true)
    @repo = Repo.from_github(json.first)
    @repo
  end

  def user
    return @user if @user
    @user = User.create_with_omniauth(auth_params)
    @user.access_token = "dummyt0k3n"
    @user.save
    @user
  end

  def auth_params
    { "provider" => "github",
      "uid" => "123",
      "info" => {
        "nickname" => 'john.doe'
      }
    }
  end

end
