class AddCoverageToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :coverage, :decimal, precision: 5, scale: 2
  end
end
