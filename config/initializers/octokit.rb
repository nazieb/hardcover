Octokit.configure do |c|
  c.api_endpoint = APP_CONFIG['github_api_endpoint']
  c.web_endpoint = APP_CONFIG['github_web_endpoint']
end
Octokit.auto_paginate = true
