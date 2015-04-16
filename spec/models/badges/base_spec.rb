require 'rails_helper'

describe Badges::Base do
  subject do
    described_class.new(
      font: '11px Verdana, "DejaVu Sans"',
      left_text: 'lefttext',
      left_color: 'leftcolor',
      right_text: 'righttext',
      right_color: 'rightcolor'
    )
  end

  describe '#initialize' do
    it 'instanciates with all options set' do
      expect(subject.left_text).to eq('lefttext')
      expect(subject.left_color).to eq('leftcolor')
      expect(subject.right_text).to eq('righttext')
      expect(subject.right_color).to eq('rightcolor')
      expect(subject.font).to eq('11px Verdana, "DejaVu Sans"')
    end
  end

  describe '.left_text_x' do
    it 'calculates the x coordinate' do
      expect(subject).to receive(:left_width).and_return(10)

      expect(subject.left_text_x).to be(6.0)
    end
  end

  describe '.right_text_x' do
    it 'calculates the x coordinate' do
      expect(subject).to receive(:left_width).and_return(10)
      expect(subject).to receive(:right_width).and_return(10)

      expect(subject.right_text_x).to be(14.0)
    end
  end

  describe '.right_width' do
    it 'calculates the width' do
      expect(subject).to receive(:text_width).with('righttext').and_return(10)

      expect(subject.right_width).to be(20)
    end
  end

  describe '.left_width' do
    it 'calculates the width' do
      expect(subject).to receive(:text_width).with('lefttext').and_return(10)

      expect(subject.left_width).to be(20)
    end
  end

  describe '.text_width' do
    let(:example_text) { 'Hardcover is awesome shit' }

    it 'instanciates a new Magic::Draw object' do
      expect(Magick::Draw).to receive(:new).and_call_original

      subject.text_width(example_text)
    end

    context 'with stubbed instance' do
      let(:draw_double) { double }
      let(:metrics_double) { double }
      before do
        expect(Magick::Draw).to receive(:new).and_return(draw_double)
      end

      it 'sets the attributes and return the width' do
        expect(draw_double).to receive(:font=).with(subject.font)
        expect(draw_double).to receive(:font_weight=).with(Magick::BoldWeight)
        expect(draw_double).to receive(:get_type_metrics).with(example_text).and_return(metrics_double)
        expect(metrics_double).to receive(:width).and_return(42)

        expect(subject.text_width(example_text)).to be(42)
      end

    end
  end
end
