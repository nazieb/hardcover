class ReposController < ApplicationController
  before_filter :redirect_to_root_page_if_logged_out,
                only: [:fetch_repos]

  def index
    if org = params[:org]
      @repos = Repo.where(login: org).where(is_private: false).group_by(&:login)
      @all_repos = Repo.all.group_by(&:login)
      not_found if @repos.none?
    else
      @repos = Repo.all.preload(:jobs).where(is_private: false).group_by(&:login)
      @all_repos = @repos
    end
  end

  def fetch_repos
    current_user.fetch_repos
    redirect_to repos_path
  end
end
