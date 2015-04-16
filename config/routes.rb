Rails.application.routes.draw do
  default_url_options host: Rails.application.config.domain

  root to: "repos#index"

  # sessions_controller
  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout

  # badges_controller
  get "/repos/:org/:repo_name(/:job_id)(/:source_id)/badge" => "badges#show", :as => :badge

  # repos_controller
  get "/repos(/:org)" => "repos#index", :as => :repos
  get "/fetch_repos" => "repos#fetch_repos", :as => :fetch_repos

  # jobs_controller
  get "/repos/:org/:repo_name" => "jobs#index", :as => :jobs

  # source_files_controller
  get "/repos/:org/:repo_name/:job_id" => "source_files#index", :as => :source_files
  get "/repos/:org/:repo_name/:job_id/:source_id" => "source_files#show", :as => :source_file

  scope "(api)", :locale => /api/ do
    scope module: 'api' do
      namespace :v1 do
        post '/jobs', to: 'jobs#create'
      end
    end
  end
end
