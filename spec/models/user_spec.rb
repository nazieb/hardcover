require 'rails_helper'

RSpec.describe User, :type => :model do

  it "Create Octokit client with access_token" do
    user = user_mock
    expect(user.github_client).to be_instance_of(Octokit::Client)
    expect(user.github_client.access_token).to eql(user.access_token)
  end

  it 'Gets all user repos' do
    user = user_mock
    expected_result = [{:id=>123, :owner=>{:login=>"hans"}, :full_name=>"hans/hardcover", :name=>"hardcover"},
                       {:id=>456, :owner=>{:login=>"xing"}, :full_name=>"xing/XNGAPIClient", :name=>"XNGAPIClient"}]

    github_client = github_client_mock
    allow(user).to receive(:github_client) {github_client}

    expect(user.github_repos).to eql(expected_result)
  end

  it 'should fetch all repos' do
      user = user_mock
      github_client = github_client_mock
      allow(user).to receive(:github_client) {github_client}

      user.fetch_repos
      expect(Repo.find_by_id(123).name).to eql('hardcover')
      expect(Repo.find_by_id(456).name).to eql('XNGAPIClient')
  end


  private

    def github_client_mock
      githubclientmock = Struct.new(:repos, :orgs, :org_repositories) do
        def org_repos(*args)
          org_repositories
        end
      end.new(repos_hash, orgs_hash, org_repos_hash)
    end

    def org_repos_hash
      [{ id: 456, owner: {login: 'xing'}, full_name: 'xing/XNGAPIClient', name: 'XNGAPIClient' }]
    end

    def repos_hash
      [{ id: 123, owner: {login: 'hans'}, full_name: 'hans/hardcover', name: 'hardcover' }]
    end

    def orgs_hash
      orgmock = Struct.new(:login)
      [orgmock.new("xing")]
    end

    def user_mock
      new_user = User.new(provider: 'github', uid: '123', name: "Hans", access_token: 'T0k3N')
      new_user.save
      new_user
    end
end
