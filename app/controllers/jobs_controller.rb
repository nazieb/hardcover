class JobsController < ApplicationController

  def index
    if @repo = Repo.find_by(login: params[:org], name: params[:repo_name])
      @jobs = @repo.jobs.order('id DESC')
    else
      render plain: "404 Not Found", status: 404 and return unless @repo
    end
  end

end
