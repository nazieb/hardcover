class AddJobsCountToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :jobs_count, :integer, default: 0
  end
end
