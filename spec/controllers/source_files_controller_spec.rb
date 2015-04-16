require 'rails_helper'

RSpec.describe SourceFilesController, :type => :controller do
  before do
    @repo = Repo.create(login: "ios", name: "hardcover")
    json_hash = JSON.parse(File.read("spec/fixtures/job.json"))
    @job = Job.from_hash(json_hash)
  end

  describe '#index' do
    it 'should load the correct models' do
      get :index, org: "ios", repo_name: "hardcover", job_id: @job.id
      expect(assigns(:repo)).to eq(@repo)
      expect(assigns(:job)).to eq(@job)
      expect(assigns(:source_files)).to eq(@job.source_files)
    end
  end

  describe '#show' do
    it 'should load the correct models' do
      get :show, org: "ios", repo_name: "hardcover",
        job_id: @job.id, source_id: @job.source_files.last.id
      expect(assigns(:repo)).to eq(@repo)
      expect(assigns(:job)).to eq(@job)
      expect(assigns(:file)).to eq(@job.source_files.last)
      expect(assigns(:lines).count).to eq(95)
    end
  end
end
