require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do

  context "#coverage_class" do
    it "returns good coverage" do
      expect(coverage_class(90.1)).to eq("good coverage")
      expect(coverage_class(100)).to eq("good coverage")
    end

    it "returns bad coverage" do
      expect(coverage_class(80.1)).to eq("bad coverage")
      expect(coverage_class(90)).to eq("bad coverage")
    end

    it "returns awful coverage" do
      expect(coverage_class(0)).to eq("awful coverage")
      expect(coverage_class(80)).to eq("awful coverage")
    end

    it "returns coverage if percentage is empty" do
      expect(coverage_class(nil)).to eq("coverage")
    end
  end

  context "#crumbs" do
    describe "path recognition" do
      it "#source_file_detail?" do
        allow(helper).to receive(:params) { { org: "some", repo_name: "name", job_id: 1, source_id: 2 } }
        expect(helper.send(:source_file_detail?)).to be_truthy
      end

      it "#job_detail?" do
        allow(helper).to receive(:params) { { org: "some", repo_name: "name", job_id: 1 } }
        expect(helper.send(:job_detail?)).to be_truthy
      end

      it "#job_overview?" do
        allow(helper).to receive(:params) { { org: "some", repo_name: "name" } }
        expect(helper.send(:job_overview?)).to be_truthy
      end
    end

    describe "#job_overview_crumbs" do
      it "returns correct crumbs" do
        allow(helper).to receive(:params) { { org: "some", repo_name: "name" } }
        expected = [{title: "Overview", link: "/repos"},
                    {title: "some", link: "/repos/some"},
                    {title: "name", link: "/repos/some/name"}]
        expect(helper.send(:job_overview_crumbs)).to eq(expected)
      end
    end

    describe "#crumbs" do
      before do
        hash = JSON.parse(File.read("spec/fixtures/job.json")).to_hash
        hash['repo_token'] = "f06d9a9be5216be600178e672ea73b9b"
        @job = Job.from_hash(hash)
      end

      it "returns crumbs for jobs_overview" do
        allow(helper).to receive(:params) { { org: "some", repo_name: "name" } }
        expected = [{title: "Overview", link: "/repos"},
                    {title: "some", link: "/repos/some"},
                    {title: "name", link: "/repos/some/name"}]
        expect(helper.crumbs).to eq(expected)
      end

      it "returns crumbs for jobs_detail" do
        allow(helper).to receive(:params) { { org: "some", repo_name: "name", job_id: @job.id } }
        expected = [{title: "Overview", link: "/repos"},
                    {title: "some", link: "/repos/some"},
                    {title: "name", link: "/repos/some/name"},
                    {title: "Build #1248", link: "/repos/some/name/#{@job.id}"}]
        expect(helper.crumbs).to eq(expected)
      end

      it "returns crumbs for source_detail" do
        allow(helper).to receive(:params) { { org: "some", repo_name: "name", job_id: @job.id, source_id: @job.source_files.last.id } }
        expected = [{title: "Overview", link: "/repos"},
                    {title: "some", link: "/repos/some"},
                    {title: "name", link: "/repos/some/name"},
                    {title: "Build #1248", link: "/repos/some/name/#{@job.id}"},
                    {title: "XNGOAuthToken.m", link: "/repos/some/name/#{@job.id}/#{@job.source_files.last.id}"}]
        expect(helper.crumbs).to eq(expected)
      end
    end
  end

end
