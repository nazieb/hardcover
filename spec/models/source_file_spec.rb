require 'rails_helper'

RSpec.describe SourceFile, :type => :model do
  context "File with 100% test coverage" do
    before do
      json = JSON.parse(File.read("spec/fixtures/source_file_100.json"))
      @subject = SourceFile.create(json.to_hash)
    end

    it "can be created from a JSON" do
      expect(@subject.name).to eq("XNGOAuth1Client/NSDictionary+XNGOAuth1Additions.m")
      expect(@subject.source.lines.count).to eq(37)
      expect(@subject.coverage.count).to eq(37)
    end

    it "has a valid coverage percentage" do
      expect(@subject.num_lines_testable).to eq(21)
      expect(@subject.num_lines_tested).to eq(21)
      expect(@subject.num_lines_missed).to eq(0)
      expect(@subject.coverage_percentage).to eq(100)
      expect(@subject.hits_per_line(10)).to eq(4)
    end
  end

  context "File with normal test coverage" do
    before do
      @json = JSON.parse(File.read("spec/fixtures/source_file_90.json"))
    end

    it "can be created from a JSON" do
      subject = SourceFile.create(@json.to_hash)
      expect(subject.name).to eq("XNGOAuth1Client/XNGOAuth1RequestOperationManager.m")
      expect(subject.source.lines.count).to eq(124)
      expect(subject.coverage.count).to eq(124)
      subject.destroy
    end

    it "has a valid coverage percentage" do
      subject = SourceFile.create(@json.to_hash)
      expect(subject.num_lines_testable).to eq(87)
      expect(subject.num_lines_tested).to eq(68)
      expect(subject.num_lines_missed).to eq(19)
      expect(subject.coverage_percentage).to eq(78.16)
      expect(subject.hits_per_line(10)).to eq(7)
      subject.destroy
    end

    it "can handle 0 testable lines" do
      subject = SourceFile.create(@json.to_hash)
      allow(subject).to receive(:num_lines_testable) { 0 }
      allow(subject).to receive(:num_lines_tested) { 0 }
      expect(subject.calculate_coverage_percentage).to eq(100)
    end
  end
end
