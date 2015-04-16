class SourceFile < ActiveRecord::Base
  has_one :job
  before_create :calculate_coverage_percentage

  def coverage=(arr)
    write_attribute(:coverage, arr.to_json)
  end

  def coverage
    JSON.parse(read_attribute(:coverage))
  end

  def calculate_coverage_percentage
    if num_lines_testable == 0
      return 100
    end
    percent = num_lines_tested / num_lines_testable
    percent = percent * 100
    self.coverage_percentage = percent.round(2)
  end

  def num_lines_testable
    hits.count * 1.0
  end

  def num_lines_tested
    coverage.select { |i| !i.nil? && i > 0 }.count * 1.0
  end

  def num_lines_missed
    num_lines_testable - num_lines_tested
  end

  def hits_per_line(line_number)
    self.coverage[line_number]
  end

  private

    def hits
      coverage.select { |i| !i.nil? }
    end

end
