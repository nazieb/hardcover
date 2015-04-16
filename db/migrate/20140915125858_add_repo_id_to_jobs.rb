class AddRepoIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :repo_id, :integer
  end
end
