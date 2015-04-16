module ApplicationHelper

  def coverage_class(percentage)
    return "coverage" unless percentage
    case percentage
    when 0..80
      "awful coverage"
    when 80..90
      "bad coverage"
    else
      "good coverage"
    end
  end

  def crumbs
    if source_file_detail? || job_detail?
      job = Job.find_by(id: params[:job_id])
      build_number = "Build ##{job.service_job_id.split("/").last}"
      job_path = source_files_path(params[:org], params[:repo_name], job)
    end

    if job_overview?
      crumbs = job_overview_crumbs
    end

    if job_detail?
      crumbs << { title: build_number, link: job_path }
    end

    if source_file_detail?
      file = SourceFile.find_by(id: params[:source_id])
      file_path = source_file_path(params[:org], params[:repo_name], job, file.id)
      crumbs << { title: file.name.split("/").last, link: file_path }
    end
    crumbs || []
  end

  private
  def job_overview_crumbs
    [{ title: "Overview", link: repos_path },
     { title: params[:org], link: repos_path(params[:org]) },
     { title: params[:repo_name], link: jobs_path(params[:org], params[:repo_name]) }]
  end

  def source_file_detail?
    params.key?(:org) && params.key?(:repo_name) && params.key?(:job_id) && params.key?(:source_id)
  end

  def job_detail?
    params.key?(:org) && params.key?(:repo_name) && params.key?(:job_id)
  end

  def job_overview?
    params.key?(:org) && params.key?(:repo_name)
  end

end
