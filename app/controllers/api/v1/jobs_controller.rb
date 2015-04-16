module Api::V1
  class JobsController < ApiController
    def create
      json_content = params['json_file'].read
      json_hash = JSON.parse(json_content).to_hash
      job = Job.from_hash(json_hash)
      unless job.errors.empty?
        render json: { message: job.errors.first.last }, status: 400
      else
        url = source_files_url(job.repo.login, job.repo.name, job.id)
        render json: { message: "Job ##{job.id}", url: url }
      end
    end
  end
end
