module Badges
  class Coverage < Base
    def initialize(percentage)
      super(
        font: '11px Verdana, "DejaVu Sans"',
        left_text: 'coverage',
        left_color: '#555',
        right_text: "#{percentage.to_i} %",
        right_color: color(percentage)
      )
    end

    def color(percentage)
      case percentage
      when 0..80
        '#e05d44'
      when 80..90
        '#dfb317'
      else
        '#97CA00'
      end
    end
  end
end
