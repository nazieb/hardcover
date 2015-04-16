require 'rails_helper'

RSpec.describe SourceFilesHelper, :type => :helper do
  before do
    params = {
      name: "TestFile",
      source: "one\ntwo\nthree\n",
      coverage: [nil, 0, 2]
    }
    @subject = SourceFile.new(params)
  end

  context "#coverage_status_for_line" do
    it "returns never for not relevant line" do
      expect(coverage_status_for_line(@subject, 0)).to eq("never")
    end

    it "returns missed for not covered line" do
      expect(coverage_status_for_line(@subject, 1)).to eq("missed")
    end

    it "returns covered for covered line" do
      expect(coverage_status_for_line(@subject, 2)).to eq("covered")
    end
  end

  context "#bagde_for_line" do
    it "returns nothing when not relevant" do
      expect(badge_for_line(@subject, 0)).to be_nil
    end

    it "returns danger when 0 hits" do
      expect(badge_for_line(@subject, 1)).to eq("<span class=\"badge alert-danger\">!</span>")
    end

    it "returns success when 2 hits" do
      expect(badge_for_line(@subject, 2)).to eq("<span class=\"badge alert-success\">2x</span>")
    end
  end
end
