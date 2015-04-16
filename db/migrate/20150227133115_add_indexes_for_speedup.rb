class AddIndexesForSpeedup < ActiveRecord::Migration
  def up
    add_index :source_files, [:job_id]
    add_index :jobs, [:repo_id]
  end
end
