require 'rails_helper'

RSpec.describe ReposHelper, :type => :helper do
  it "returns trend increase when coverage is greater" do
    expect(coverage_trend(78, 70)).to eq('trend increase')
  end

  it "returns trend same when coverage is equal" do
    expect(coverage_trend(70, 70)).to eq('trend same')
  end

  it "returns trend decrease when coverage is smaller" do
    expect(coverage_trend(70, 78)).to eq('trend decrease')
  end

  it "returns trend initial when no before value is given" do
    expect(coverage_trend(70, nil)).to eq('trend initial')
  end

  it "returns the repo badge for markdown" do
    repo = Repo.new(login: "piet-brauer", name: "hardcover")
    expect(repo_badge_md(repo)).to eq("[![Coverage Status](http://test.host/repos/piet-brauer/hardcover/badge.svg?style=flat-square)](http://test.host/repos/piet-brauer/hardcover)")
  end
end
