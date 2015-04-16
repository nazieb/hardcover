class GenerateCoveragePercentageForSourceFiles < ActiveRecord::Migration
  def change
    source_files = SourceFile.all
    source_files.each do |source_file|
      source_file.calculate_coverage_percentage
      source_file.save
    end
  end
end
