require 'rails_helper'

module Api::V1
  RSpec.describe JobsController, :type => :controller do
    it "creates a new job" do
      Repo.create(name: "iphone-app", login: "ios")
      post :create, :json_file => fixture_file_upload("job.json", "application/json")
      expect(response).to be_success
      subject = Job.all.last

      expect(JSON.parse(response.body).to_hash).to eq({"message" => "Job ##{subject.id}",
                                                       "url" => "http://test.host/repos/ios/iphone-app/#{subject.id}"})

      expect(subject.service_job_id).to eq("iphone-app-unit-tests/1248")
      expect(subject.service_name).to eq("travis-ci")
      expect(subject.source_files.count).to eq(5)
      expect(subject.coverage_percentage.to_f).to eq(88.24)
    end

    it "returns error if job is invalid" do
      Repo.create(name: "iphone-app", login: "ios")
      post :create, :json_file => fixture_file_upload("invalid_job.json", "application/json")
      expect(response.status).to eq(400)
      body = JSON.parse(response.body).to_hash
      expect(body['message']).to eq("Only travis-ci and jenkins-ci are supported by now.")
    end
  end
end
