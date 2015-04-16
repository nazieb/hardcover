class AddCoveragePercentageToSourceFiles < ActiveRecord::Migration
  def change
    add_column :source_files, :coverage_percentage, :decimal, precision: 5, scale: 2
  end
end
