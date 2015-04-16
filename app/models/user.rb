class User < ActiveRecord::Base

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

  def github_repos
    repos = github_client.repos
    github_client.orgs.each do |org|
      repos << github_client.org_repos(org.login, {type: 'all'})
    end
    repos.flatten!
  end

  def github_client
    @client ||= Octokit::Client.new(access_token: self.access_token)
  end

  def fetch_repos
    github_repos.each do |params|
      repo = Repo.from_github(params)
      repo.save if repo.changed?
    end
  end

end
