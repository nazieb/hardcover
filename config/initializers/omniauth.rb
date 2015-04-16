# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user:email,user:follow"
  provider :github,
    APP_CONFIG['github_application_key'],
    APP_CONFIG['github_application_secret'],
    {
      :client_options => {
        :site => APP_CONFIG['github_api_endpoint'],
        :authorize_url => "#{APP_CONFIG['github_web_endpoint']}/login/oauth/authorize",
        :token_url => "#{APP_CONFIG['github_web_endpoint']}/login/oauth/access_token",
      },
      scope: "user,repo,user:email,user:follow"
    }
end
