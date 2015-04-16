require 'rails_helper'

describe Badges::CoveragePending do
  describe '#initialize' do
    it 'instanciates with all options set' do
      expect(subject.left_text).to eq('coverage')
      expect(subject.left_color).to eq('#555')
      expect(subject.right_text).to eq('pending')
      expect(subject.right_color).to eq('#9f9f9f')
      expect(subject.font).to eq('11px Verdana, "DejaVu Sans"')
    end
  end
end
