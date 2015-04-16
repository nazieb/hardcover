require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#avatar_url" do
    it "returns the right url" do
      url = "https://github.com/api/v3/user"
      stub = stub_request(:get, url).to_return(json_response("gh_user"))
      allow(subject).to receive(:current_user) { User.new(id: 1) }
      expect(subject.send(:avatar_url)).to eq("https://github.com/images/error/octocat_happy.gif")
    end
  end
end
