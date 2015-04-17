class SourceFilesController < ApplicationController

  def index
    @repo = Repo.find_by(login: params[:org], name: params[:repo_name])
    if @repo.user_has_access?(current_user)
      @job = @repo.jobs.find_by(id: params[:job_id])
      @source_files = @job.source_files
    else
      render plain: "404 Not Found", status: 404
    end
  end

  def show
    @repo = Repo.find_by(login: params[:org], name: params[:repo_name])
    if @repo.user_has_access?(current_user)
      @job = @repo.jobs.find_by(id: params[:job_id])
      @file = SourceFile.find_by_id(params[:source_id])
      @lines = @file.source.split("\n")
    else
      render plain: "404 Not Found", status: 404
    end
  end

end
