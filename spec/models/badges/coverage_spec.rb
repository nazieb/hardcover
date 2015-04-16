require 'rails_helper'

describe Badges::Coverage do
  let(:coverage) { 100 }
  subject do
    described_class.new(coverage)
  end

  it 'sets left side of badge correctly' do
    expect(subject.left_text).to eq('coverage')
    expect(subject.left_color).to eq('#555')
  end

  it 'sets font correctly' do
    expect(subject.font).to eq('11px Verdana, "DejaVu Sans"')
  end

  context '0% coverage' do
    let(:coverage) { 0 }

    it 'sets the right side of badge correctly' do
      expect(subject.right_text).to eq('0 %')
      expect(subject.right_color).to eq('#e05d44')
    end
  end

  context '80% coverage' do
    let(:coverage) { 80 }

    it 'sets the right side of badge correctly' do
      expect(subject.right_text).to eq('80 %')
      expect(subject.right_color).to eq('#e05d44')
    end
  end

  context '81% coverage' do
    let(:coverage) { 81 }

    it 'sets the right side of badge correctly' do
      expect(subject.right_text).to eq('81 %')
      expect(subject.right_color).to eq('#dfb317')
    end
  end

  context '90% coverage' do
    let(:coverage) { 90 }

    it 'sets the right side of badge correctly' do
      expect(subject.right_text).to eq('90 %')
      expect(subject.right_color).to eq('#dfb317')
    end
  end

  context '91% coverage' do
    let(:coverage) { 91 }

    it 'sets the right side of badge correctly' do
      expect(subject.right_text).to eq('91 %')
      expect(subject.right_color).to eq('#97CA00')
    end
  end

  context '100% coverage' do
    let(:coverage) { 100 }

    it 'sets the right side of badge correctly' do
      expect(subject.right_text).to eq('100 %')
      expect(subject.right_color).to eq('#97CA00')
    end
  end

end
