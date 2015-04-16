class Repo < ActiveRecord::Base
  has_many :jobs
  before_create :set_repo_token

  def set_repo_token
    self.repo_token = Digest::MD5.new.hexdigest(self.id.to_s)
  end

  def self.from_github(params)
    repo = Repo.find_or_initialize_by(id: params[:id])
    repo.id = params[:id]
    repo.login = params[:owner][:login]
    repo.full_name = params[:full_name]
    repo.name = params[:name]
    repo.set_repo_token
    repo
  end

  def coverage_percentage
    last_job.coverage_percentage
  end

  def last_job(branch="master")
    # TODO: handle github default branch instead of master
    job_for_branch(branch) || job_for_branch("master")
  end

  def job_for_branch(branch)
    self.jobs.where(branch: branch).last
  end
end
