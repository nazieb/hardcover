module ReposHelper

  def coverage_trend(coverage, coverage_before)
    return "trend initial" unless coverage_before
    if coverage > coverage_before
      "trend increase"
    elsif coverage == coverage_before
      "trend same"
    else
      "trend decrease"
    end
  end

  def repo_badge_md(repo)
    badge_url = badge_url(org: repo.login, repo_name: repo.name, format: :svg, style: 'flat-square')
    "[![Coverage Status](#{badge_url})](#{jobs_url(repo.login, repo.name)})"
  end

end
