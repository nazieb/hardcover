require 'rails_helper'

RSpec.describe Repo, :type => :model do

  before do
    json = JSON.parse(File.read("spec/fixtures/gh_repo.json"), :symbolize_names => true)
    @subject = Repo.from_github(json.first)
  end

  it "can be created from github json" do

    expect(@subject.id).to eq(1296269)
    expect(@subject.full_name).to eq("octocat/Hello-World")
    expect(@subject.login).to eq("octocat")
    expect(@subject.name).to eq("Hello-World")
    expect(@subject.repo_token).to eq("f06d9a9be5216be600178e672ea73b9b")
  end

  describe "#last_job" do
    it "returns nil if no job was found" do
      expect(@subject.last_job).to be_nil
    end

    it "returns a job if branch is master" do
      job = job("master")
      expect(@subject.last_job).to eq(job)
    end

    it "returns a job if branch is master" do
      job = job("feature/branch")
      expect(@subject.last_job).to be_nil
    end
  end

  describe "#last_job" do
    it "returns the coverage of the last job" do
      job = job("master")
      expect(@subject.coverage_percentage).to eq(100)
    end
  end

  def job(branch)
    file = SourceFile.create(name: "File", source: "method", coverage: [1])
    Job.create(branch: branch,
               repo_token: @subject.repo_token,
               service_job_id: "iphone-tests",
               service_name: "jenkins-ci",
               repo: @subject,
               source_files: [file])
  end
end
