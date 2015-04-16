class SourceFilesController < ApplicationController

  def index
    @repo = Repo.find_by(login: params[:org], name: params[:repo_name])
    @job = @repo.jobs.find_by(id: params[:job_id])
    @source_files = @job.source_files
  end

  def show
    @repo = Repo.find_by(login: params[:org], name: params[:repo_name])
    @job = @repo.jobs.find_by(id: params[:job_id])
    @file = SourceFile.find_by_id(params[:source_id])
    @lines = @file.source.split("\n")
  end

end
