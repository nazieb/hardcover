module Badges
  class CoveragePending < Base
    def initialize
      super(
        font: '11px Verdana, "DejaVu Sans"',
        left_text: 'coverage',
        left_color: '#555',
        right_text: 'pending',
        right_color: '#9f9f9f'
      )
    end
  end
end
