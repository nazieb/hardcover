class Job < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  validates :service_job_id, presence: true
  validates  :repo_token, presence: true
  validate :validate_service_name
  validates :service_job_id, uniqueness: true

  belongs_to :repo, counter_cache: true
  has_many :source_files
  accepts_nested_attributes_for :source_files
  before_create :set_repo, :set_coverage
  after_create :comment_on_pull_request, if: Proc.new { ENV['RAILS_ENV'] == 'production' }

  def set_coverage
    return if coverage
    self.coverage = calculate_coverage
  end

  def set_repo
    self.repo = Repo.find_by(repo_token: self.repo_token)
  end

  def coverage_percentage
    coverage
  end

  def calculate_coverage
    total_lines_testable = source_files.map(&:num_lines_testable).inject(&:+)
    total_lines_tested = source_files.map(&:num_lines_tested).inject(&:+)

    percent = total_lines_tested.to_f / total_lines_testable.to_f
    (percent * 100).round(2)
  end

  def self.from_hash(hash)
    source_files = hash['source_files']
    hash.select! { |k, v| self.column_names.include? k }
    hash['source_files_attributes'] = source_files
    self.create(hash)
  end

  private
  TRAVIS_CI="travis-ci"
  JENKINS_CI="jenkins-ci"
  JENKINS="jenkins"

  def comment_on_pull_request
    if should_comment? service_name
      branch = jenkins_get_branch
      pr = github_pr(repo.full_name, branch)
      github_add_status(repo.full_name) if pr
    end
  end

  def github_pr(full_name, branch)
    if full_name && branch
      prs = Octokit.pull_requests(full_name, :state => 'open')
      branches = prs.map(&:head).map(&:ref)
      index = branches.find_index(branch)
      if index != nil
        pr = prs[index]
      end
      pr
    end
  end

  def github_add_status(full_name)
    client = Octokit::Client.new(access_token: APP_CONFIG['github_user_access_token'])
    opts = {
      target_url: source_files_url(self.repo.login, self.repo.name, self.id),
      context: "hardcover",
      description: comment
    }
    client.create_status(full_name, self.sha, 'success', opts)
  end

  def should_comment?(service_name)
    [JENKINS_CI, JENKINS].include? service_name
  end

  def jenkins_get_branch
    url = URI.parse(JenkinsBuild.url(service_job_id))
    response = Net::HTTP.start(url.host, use_ssl: APP_CONFIG['jenkins_use_ssl']) do |http|
      resp = http.get url.request_uri
    end

    case response
    when Net::HTTPSuccess
      build = JenkinsBuild.new(JSON.parse(response.body, symbolize_names: true))
      self.branch = build.branch
      self.sha = build.sha1
    end
    self.save
    self.branch
  end

  def comment(branch="master")
    relative_cov_comment(self.repo.last_job(branch))
  end

  def relative_cov_comment(master_job)
    current_cov = self.coverage_percentage.round(2)
    if master_job
      relative, diff_cov = relative_coverage(master_job)
      diff_cov = diff_cov.round(2)
      case relative
      when :increased
        comment = "Coverage increased (#{diff_cov} %) to #{current_cov} %."
      when :equal
        comment = "Coverage remained the same."
      when :decreased
        comment = "Coverage decreased (#{diff_cov} %) to #{current_cov} %."
      end
    else
      comment = "Coverage is at #{current_cov} %."
    end
    comment
  end

  def relative_coverage(master_job)
    current_cov = self.coverage_percentage
    master_cov = master_job.coverage_percentage
    diff_cov = current_cov - master_cov
    if master_cov < current_cov
      return :increased, diff_cov
    elsif master_cov == current_cov
      return :equal, diff_cov
    else
      return :decreased, diff_cov
    end
  end

  def validate_service_name
    unless [TRAVIS_CI, JENKINS_CI, JENKINS].include?(self.service_name)
      errors.add(:service_name, "Only #{TRAVIS_CI} and #{JENKINS_CI} are supported by now.")
    end
  end
end
