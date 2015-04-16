require 'rails_helper'

RSpec.describe JenkinsBuild, :type => :model do
  it "can be created from a JSON" do
    file = File.read("spec/fixtures/jenkins_build_response.json")
    json = JSON.parse(file, symbolize_names: true)
    subject = JenkinsBuild.new(json)
    expect(subject.branch).to eq("master")
    expect(subject.sha1).to eq("4fb1c8a913e2600e88bc96ffbed414460906bd22")
  end

  it "can be created from a differenct JSON" do
    file = File.read("spec/fixtures/jenkins_build_response_2.json")
    json = JSON.parse(file, symbolize_names: true)
    subject = JenkinsBuild.new(json)
    expect(subject.branch).to eq("master")
    expect(subject.sha1).to eq("69bf025131476911fa4ed02e9a86e2df3af74e8b")
  end

  context "branch parsing" do
    before do
      @subject = JenkinsBuild.new
    end

    it "can deal with feature branches" do
      branch = @subject.send(:parse_branch, "origin/hardcover/feature_1")
      expect(branch).to eq("hardcover/feature_1")
    end

    it "can deal with normal branch" do
      branch = @subject.send(:parse_branch, "origin/master")
      expect(branch).to eq("master")
    end

    it "can deal with no origin" do
      branch = @subject.send(:parse_branch, "master")
      expect(branch).to eq("master")
    end
  end

  context "jenkins url" do
    it "returns a valid URL" do
      url = JenkinsBuild.url("hardcover-spec/1234")
      expect(url).to eq("http://ci.example.com/job/hardcover-spec/1234/api/json")
    end
  end
end
