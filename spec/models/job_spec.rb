require 'rails_helper'

RSpec.describe Job, :type => :model do
  before do
    json = JSON.parse(File.read("spec/fixtures/gh_repo.json"), :symbolize_names => true)
    @repo = Repo.from_github(json.first)
    @repo.save
    hash = JSON.parse(File.read("spec/fixtures/job.json")).to_hash
    hash['repo_token'] = @repo.repo_token
    @json_hash = hash
  end

  it "can be created from a JSON" do
    subject = Job.from_hash(@json_hash)
    subject.branch = "feature"

    expect(subject.service_job_id).to eq("iphone-app-unit-tests/1248")
    expect(subject.service_name).to eq("travis-ci")
    expect(subject.source_files.count).to eq(5)
    expect(subject.coverage_percentage.to_f).to eq(88.24)
    expect(subject.repo_token.length).to eq(32)
    expect(subject.repo).to eq(@repo)
    link = "http://hardcover.xing.hh/repos/octocat/Hello-World/#{subject.id}"
    mdown_comment = "[![](#{link}/badge.svg?style=flat-square)](#{link})\n\nCoverage increased (88.24 %) when pulling **feature** into **master**."
    expect(subject.send(:comment)).to eq(mdown_comment)
  end

  describe "#validation" do
    before :each do
      @subject = Job.from_hash(@json_hash)
    end

    it "has a valid json" do
      expect(@subject.valid?).to be true
    end

    it "validates service name jenkins_ci" do
      @subject.service_name = "jenkins-ci"
      expect(@subject.valid?).to be true
    end

    it "validates service name travis ci" do
      @subject.service_name = "travis-ci"
      expect(@subject.valid?).to be true
    end

    it "does not validate weird service" do
      @subject.service_name = "weird-ci"
      expect(@subject.valid?).to be false
      expect(@subject.errors.first).to eq([:service_name, "Only travis-ci and jenkins-ci are supported by now."])
    end

    it "does not validate empty service_job_id" do
      @subject.service_job_id = ""
      expect(@subject.valid?).to be false
    end

    it "does not validate empty repo_token" do
      @subject.repo_token = ""
      expect(@subject.valid?).to be false
    end
  end

  describe "#relative_coverage" do
    before(:each) do
      @subject = Job.new
      allow(@subject).to receive(:coverage_percentage) { 0 }
      @master = double()
      allow(@master).to receive(:coverage_percentage) { 0 }
    end

    it "returns decreased" do
      allow(@master).to receive(:coverage_percentage) { 100 }
      expect(@subject.send(:relative_coverage, @master)).to eq([:decreased, -100])
    end

    it "returns increased" do
      allow(@subject).to receive(:coverage_percentage) { 100 }
      expect(@subject.send(:relative_coverage, @master)).to eq([:increased, 100])
    end

    it "returns equal" do
      expect(@subject.send(:relative_coverage, @master)).to eq([:equal, 0])
    end
  end

  describe "#comment_on_pull_request" do
    it "comments on the pull request" do
      subject = Job.new
      repo = double()
      allow(subject).to receive(:should_comment?) { true }
      allow(repo).to receive(:full_name) { "octocat/Hello-World" }
      allow(subject).to receive(:jenkins_get_branch) { "some_branch" }
      allow(subject).to receive(:repo) { repo }
      expect(subject).to receive(:github_pr) { { number: 1, base: { ref: "master" } } }
      allow(subject).to receive(:comment) { "comment" }
      expect(subject).to receive(:github_add_comment).with("octocat/Hello-World", 1, "comment")
      subject.send(:comment_on_pull_request)
    end
  end

  describe "#relative_cov_comment" do
    before(:each) do
      @subject = Job.new
      allow(@subject).to receive(:coverage_percentage) { 0 }
      allow(@subject).to receive(:branch) { "branch" }
      @master = double()
      allow(@master).to receive(:coverage_percentage) { 0 }
      allow(@master).to receive(:branch) { "master" }
    end

    it "returns decreased" do
      expected = "Coverage decreased (-100.0 %) when pulling **branch** into **master**."
      allow(@master).to receive(:coverage_percentage) { 100 }
      expect(@subject.send(:relative_cov_comment, @master)).to eq(expected)
    end

    it "returns increased" do
      expected = "Coverage increased (100.0 %) when pulling **branch** into **master**."
      allow(@subject).to receive(:coverage_percentage) { 100 }
      expect(@subject.send(:relative_cov_comment, @master)).to eq(expected)
    end

    it "returns equal" do
      expected = "Coverage remained the same when pulling **branch** into **master**."
      expect(@subject.send(:relative_cov_comment, @master)).to eq(expected)
    end
  end

  describe "#github_pr" do
    before do
      @url = "https://github.com/api/v3/repos/octocat/Hello-World/pulls?per_page=100&state=open"
      stub_request(:get, @url).to_return(json_response("gh_prs"))
    end

    it "returns a pr if one exists" do
      expect(subject.send(:github_pr, "octocat/Hello-World", "new-topic")).to_not be_nil
    end

    it "returns nil if none exists" do
      expect(subject.send(:github_pr, "octocat/Hello-World", "not-existing")).to be_nil
    end

    it "return nil of no full_name or branch given" do
      expect(subject.send(:github_pr, nil, nil)).to be_nil
    end
  end

  describe "#github_add_comment" do
    it "comments" do
      @url = "https://github.com/api/v3/repos/octocat/Hello-World/issues/1/comments"
      stub = stub_request(:post, @url).with(body: "{\"body\":\"test comment\"}").to_return(status: 200)

      subject = Job.new
      subject.send(:github_add_comment, "octocat/Hello-World", 1, "test comment")
      expect(stub).to have_been_requested
    end

    it "does nothing if number is 0" do
      subject = Job.new
      subject.send(:github_add_comment, "octocat/Hello-World", 0, "Should not work")
    end
  end

  describe "#should_comment?" do
    before(:each) { @subject = Job.new }
    it "returns true for JENKINS" do
      expect(@subject.send(:should_comment?, "jenkins-ci")).to be_truthy
      expect(@subject.send(:should_comment?, "jenkins")).to be_truthy
    end

    it "returns false for everything else" do
      expect(@subject.send(:should_comment?, "travis-ci")).to be_falsy
    end
  end

  describe "#jenkins_get_branch" do
    it "sets the branch" do
      url = JenkinsBuild.url("iphone-app-unit-tests/1248")
      response = File.new("spec/fixtures/jenkins_build_response.json")
      stub = stub_request(:get, url).to_return(body: response)

      subject = Job.from_hash(@json_hash)
      subject.send(:jenkins_get_branch)
      expect(subject.branch).to eq("master")

      expect(stub).to have_been_requested
    end
  end
end
