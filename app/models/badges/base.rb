module Badges
  class Base
    attr_reader :left_text, :right_text, :right_color, :left_color, :font

    def initialize(font:, left_text:, left_color:, right_text:, right_color:)
      @font        = font
      @left_text   = left_text.to_s
      @left_color  = left_color
      @right_text  = right_text.to_s
      @right_color = right_color
    end

    def left_text_x
      @left_text_x ||= left_width / 2.0 + 1
    end

    def right_text_x
      @right_text_x ||= left_width + right_width / 2.0 - 1
    end

    def right_width
      @right_width ||= text_width(right_text) + 10
    end

    def left_width
      @left_width ||= text_width(left_text) + 10
    end

    def text_width(text)
      label = Magick::Draw.new
      label.font = font
      label.font_weight = Magick::BoldWeight
      metrics = label.get_type_metrics(text)

      metrics.width
    end
  end
end
